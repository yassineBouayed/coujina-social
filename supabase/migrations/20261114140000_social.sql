-- =============================================================================
-- couJina social — copier, publier, suivre, classer
--
--   copy_recipe()        « Enregistrer » : la recette telle quelle dans Mes recettes
--   recipe_save()        écrire une recette, ou copier AVEC modifications
--   home_feed()          l'accueil, selon les cuisines aimées et les interdits
--   trending_recipes()   les plus copiées du jour, de la semaine, du mois
--   globe_countries()    les épingles du Tour du monde
--   profile_summary()    un profil, ses compteurs, et si je le suis
--   delete_my_account()  exigé par les deux magasins
--
-- Plus les signalements et les blocages : un réseau ouvert au public ne passe
-- pas la relecture Apple (règle 1.2) sans eux.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Blocages et signalements
-- -----------------------------------------------------------------------------
create table if not exists blocks (
  blocker_id uuid not null references profiles(id) on delete cascade,
  blocked_id uuid not null references profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  constraint blocks_not_self check (blocker_id <> blocked_id)
);

alter table blocks enable row level security;
drop policy if exists blocks_self on blocks;
create policy blocks_self on blocks for all
  using (blocker_id = app_user_id()) with check (blocker_id = app_user_id());

do $$ begin
  create type report_reason as enum ('spam', 'offensive', 'copyright', 'dangerous', 'other');
exception when duplicate_object then null; end $$;

create table if not exists reports (
  id          uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references profiles(id) on delete cascade,
  recipe_id   uuid references recipes(id) on delete cascade,
  profile_id  uuid references profiles(id) on delete cascade,
  reason      report_reason not null,
  details     text not null default '',
  status      text not null default 'open' check (status in ('open', 'actioned', 'dismissed')),
  created_at  timestamptz not null default now(),
  constraint reports_target check (recipe_id is not null or profile_id is not null)
);

alter table reports enable row level security;
drop policy if exists reports_insert on reports;
create policy reports_insert on reports for insert with check (reporter_id = app_user_id());
drop policy if exists reports_read_own on reports;
create policy reports_read_own on reports for select using (reporter_id = app_user_id());

-- La règle de visibilité, complétée par les blocages dans les deux sens.
create or replace function can_view_recipe(p_author uuid, p_visibility recipe_visibility)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select p_author = app_user_id()
      or (
        not exists (select 1 from blocks
                    where (blocker_id = p_author and blocked_id = app_user_id())
                       or (blocker_id = app_user_id() and blocked_id = p_author))
        and (
          p_visibility = 'public'
          or (p_visibility = 'followers'
              and exists (select 1 from follows
                          where follower_id = app_user_id() and followee_id = p_author))
        )
      );
$$;

-- -----------------------------------------------------------------------------
-- Le journal des copies : la matière des classements.
-- -----------------------------------------------------------------------------
create table if not exists recipe_copies (
  id         uuid primary key default gen_random_uuid(),
  source_id  uuid not null references recipes(id) on delete cascade,
  copy_id    uuid references recipes(id) on delete set null,
  copier_id  uuid not null references profiles(id) on delete cascade,
  modified   boolean not null default false,
  created_at timestamptz not null default now()
);
create index if not exists recipe_copies_window_idx on recipe_copies (created_at desc, source_id);

alter table recipe_copies enable row level security;
-- Je vois mes copies, et qui a copié mes recettes. Le classement, lui, passe
-- par une fonction qui ne rend que des comptes.
drop policy if exists recipe_copies_read on recipe_copies;
create policy recipe_copies_read on recipe_copies for select
  using (copier_id = app_user_id()
         or exists (select 1 from recipes r where r.id = source_id and r.author_id = app_user_id()));

-- -----------------------------------------------------------------------------
-- La carte d'une recette, telle que l'accueil, le globe et les classements
-- l'affichent. security_invoker : la RLS de `recipes` s'applique.
-- -----------------------------------------------------------------------------
create or replace view recipe_cards with (security_invoker = true) as
select
  r.id, r.slug, r.title, r.native_name, r.description, r.cuisine, r.country, r.meal_type,
  c.name_fr as country_name_fr, c.name_en as country_name_en, c.flag as country_flag,
  r.difficulty, r.prep_min, r.cook_min, r.total_min, r.servings, r.lang,
  r.visibility, r.cover_url, r.video_url, (r.video_url is not null) as has_video,
  r.dietary_flags, r.copies_count, r.created_at, r.updated_at, r.copied_from,
  r.author_id, a.username as author_username, a.display_name as author_name,
  a.avatar_url as author_avatar, a.is_editorial as author_is_editorial,
  r.credit_author_id, ca.username as credit_username, ca.display_name as credit_name,
  r.modified_by_id, mb.username as modified_username, mb.display_name as modified_name
from recipes r
join profiles a on a.id = r.author_id
left join countries c on c.slug = r.country
left join profiles ca on ca.id = r.credit_author_id
left join profiles mb on mb.id = r.modified_by_id;

-- Une recette « à montrer » dans les flux publics : un original, ou une
-- version modifiée par son auteur. Les copies telles quelles restent dans le
-- profil de qui les a faites, sans inonder l'accueil de doublons.
create or replace function is_showcase(p_copied_from uuid, p_modified_by uuid, p_author uuid)
returns boolean language sql immutable as $$
  select p_copied_from is null or p_modified_by = p_author;
$$;

-- -----------------------------------------------------------------------------
-- Enregistrer telle quelle
-- -----------------------------------------------------------------------------
create or replace function copy_recipe(p_source uuid, p_visibility recipe_visibility default 'private')
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  me     uuid := app_user_id();
  src    recipes;
  vis    recipe_visibility := coalesce(p_visibility, 'private');
  new_id uuid;
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;

  select * into src from recipes where id = p_source;
  if not found or not can_view_recipe(src.author_id, src.visibility) then
    raise exception 'recipe_not_found' using errcode = 'P0002';
  end if;
  if src.author_id = me then raise exception 'cannot_copy_own' using errcode = '22023'; end if;

  -- Déjà dans mes recettes, telle quelle : on rend la copie existante.
  select id into new_id from recipes
   where author_id = me and copied_from = src.id
     and modified_by_id is not distinct from src.modified_by_id;
  if found then return new_id; end if;

  -- Une copie n'est jamais plus ouverte que sa source.
  if visibility_rank(vis) > visibility_rank(src.visibility) then vis := src.visibility; end if;

  insert into recipes (
    author_id, title, native_name, description, cuisine, country, meal_type, difficulty,
    prep_min, cook_min, servings, lang, visibility, cover_url, video_url,
    dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id
  ) values (
    me, src.title, src.native_name, src.description, src.cuisine, src.country, src.meal_type, src.difficulty,
    src.prep_min, src.cook_min, src.servings, src.lang, vis, src.cover_url, src.video_url,
    src.dietary_flags, src.declared_flags, src.id,
    coalesce(src.credit_author_id, src.author_id), src.modified_by_id
  ) returning id into new_id;

  insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name)
    select new_id, position, raw, qty, unit, item, optional, group_name
      from recipe_ingredients where recipe_id = src.id;
  insert into recipe_steps (recipe_id, position, body, minutes)
    select new_id, position, body, minutes from recipe_steps where recipe_id = src.id;
  -- Les médias pointent vers les fichiers de l'original (voir ETAT.md).
  insert into recipe_media (recipe_id, owner_id, kind, storage_path, public_url, step_position, position, duration_s)
    select new_id, me, kind, storage_path, public_url, step_position, position, duration_s
      from recipe_media where recipe_id = src.id;

  insert into recipe_copies (source_id, copy_id, copier_id, modified) values (src.id, new_id, me, false);
  update recipes set copies_count = copies_count + 1 where id = src.id;
  return new_id;
end $$;

-- -----------------------------------------------------------------------------
-- Écrire, modifier, ou copier avec modifications.
--
--   p_id null, p_copied_from null   une recette à moi
--   p_id null, p_copied_from = X    une copie modifiée de X : « modifiée par moi »
--   p_id = Y                        je modifie ma recette Y ; si Y était une
--                                   copie, elle devient « modifiée par moi »
-- -----------------------------------------------------------------------------
create or replace function recipe_save(p_id uuid, p_recipe jsonb, p_copied_from uuid default null)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  me       uuid := app_user_id();
  src      recipes;
  cur      recipes;
  rid      uuid := p_id;
  vis      recipe_visibility := coalesce((p_recipe ->> 'visibility')::recipe_visibility, 'private');
  declared dietary_flag[] := coalesce(
    (select array_agg(x::dietary_flag) from jsonb_array_elements_text(p_recipe -> 'declared_flags') x), '{}');
  ingredients jsonb := coalesce(p_recipe -> 'ingredients', '[]'::jsonb);
  steps       jsonb := coalesce(p_recipe -> 'steps', '[]'::jsonb);
  flags    dietary_flag[];
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  if coalesce(btrim(p_recipe ->> 'title'), '') = '' then
    raise exception 'title_required' using errcode = '22023';
  end if;
  if jsonb_array_length(ingredients) = 0 then raise exception 'ingredients_required' using errcode = '22023'; end if;
  if jsonb_array_length(steps) = 0 then raise exception 'steps_required' using errcode = '22023'; end if;

  if p_copied_from is not null and p_id is null then
    select * into src from recipes where id = p_copied_from;
    if not found or not can_view_recipe(src.author_id, src.visibility) then
      raise exception 'recipe_not_found' using errcode = 'P0002';
    end if;
    if src.author_id = me then raise exception 'cannot_copy_own' using errcode = '22023'; end if;
    if visibility_rank(vis) > visibility_rank(src.visibility) then vis := src.visibility; end if;
  end if;

  -- Les drapeaux : ce que le référentiel trouve dans les lignes non
  -- facultatives, plus ce que l'auteur déclare. Jamais moins.
  select detect_flags(array_agg(coalesce(l ->> 'raw', '') || ' ' || coalesce(l ->> 'item', '')))
    into flags
    from jsonb_array_elements(ingredients) l
   where coalesce((l ->> 'optional')::boolean, false) = false;
  flags := (select coalesce(array_agg(distinct f order by f), '{}')
              from unnest(coalesce(flags, '{}') || declared) f);

  if rid is null then
    insert into recipes (
      author_id, title, native_name, description, cuisine, country, meal_type, difficulty,
      prep_min, cook_min, servings, lang, visibility, cover_url, video_url,
      dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id
    ) values (
      me,
      btrim(p_recipe ->> 'title'),
      nullif(btrim(coalesce(p_recipe ->> 'native_name', '')), ''),
      coalesce(p_recipe ->> 'description', ''),
      coalesce(nullif(p_recipe ->> 'cuisine', ''), src.cuisine),
      coalesce(nullif(p_recipe ->> 'country', ''), src.country),
      coalesce(nullif(p_recipe ->> 'meal_type', ''), src.meal_type),
      coalesce((p_recipe ->> 'difficulty')::recipe_difficulty, src.difficulty, 'medium'),
      (p_recipe ->> 'prep_min')::int,
      (p_recipe ->> 'cook_min')::int,
      coalesce((p_recipe ->> 'servings')::int, src.servings, 4),
      coalesce(p_recipe ->> 'lang', src.lang, 'fr'),
      vis,
      coalesce(p_recipe ->> 'cover_url', src.cover_url),
      coalesce(p_recipe ->> 'video_url', src.video_url),
      flags, declared,
      src.id,
      case when src.id is null then null else coalesce(src.credit_author_id, src.author_id) end,
      case when src.id is null then null else me end
    ) returning id into rid;

    if src.id is not null then
      insert into recipe_copies (source_id, copy_id, copier_id, modified) values (src.id, rid, me, true);
      update recipes set copies_count = copies_count + 1 where id = src.id;
    end if;
  else
    select * into cur from recipes where id = rid;
    if not found or cur.author_id <> me then
      raise exception 'recipe_not_found' using errcode = 'P0002';
    end if;
    -- Une copie reste bornée par sa source, même modifiée plus tard.
    if cur.copied_from is not null then
      select * into src from recipes where id = cur.copied_from;
      if found and visibility_rank(vis) > visibility_rank(src.visibility) then vis := src.visibility; end if;
    end if;

    update recipes set
      title          = btrim(p_recipe ->> 'title'),
      native_name    = nullif(btrim(coalesce(p_recipe ->> 'native_name', '')), ''),
      description    = coalesce(p_recipe ->> 'description', ''),
      cuisine        = nullif(p_recipe ->> 'cuisine', ''),
      country        = nullif(p_recipe ->> 'country', ''),
      meal_type      = nullif(p_recipe ->> 'meal_type', ''),
      difficulty     = coalesce((p_recipe ->> 'difficulty')::recipe_difficulty, cur.difficulty),
      prep_min       = (p_recipe ->> 'prep_min')::int,
      cook_min       = (p_recipe ->> 'cook_min')::int,
      servings       = coalesce((p_recipe ->> 'servings')::int, cur.servings),
      visibility     = vis,
      cover_url      = p_recipe ->> 'cover_url',
      video_url      = p_recipe ->> 'video_url',
      dietary_flags  = flags,
      declared_flags = declared,
      modified_by_id = case when cur.credit_author_id is not null then me else null end,
      updated_at     = now()
    where id = rid;

    delete from recipe_ingredients where recipe_id = rid;
    delete from recipe_steps where recipe_id = rid;
  end if;

  insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name)
    select rid, (ord - 1)::int,
           coalesce(l ->> 'raw', l ->> 'item', ''),
           (l ->> 'qty')::numeric, nullif(l ->> 'unit', ''),
           coalesce(l ->> 'item', ''),
           coalesce((l ->> 'optional')::boolean, false),
           nullif(l ->> 'group', '')
      from jsonb_array_elements(ingredients) with ordinality as t(l, ord);

  insert into recipe_steps (recipe_id, position, body, minutes)
    select rid, (ord - 1)::int, coalesce(s ->> 'body', ''), (s ->> 'minutes')::int
      from jsonb_array_elements(steps) with ordinality as t(s, ord);

  return rid;
end $$;

-- Changer seulement la confidentialité, depuis le profil.
create or replace function recipe_set_visibility(p_id uuid, p_visibility recipe_visibility)
returns recipe_visibility
language plpgsql
security definer
set search_path = public
as $$
declare
  cur recipes;
  src recipes;
  vis recipe_visibility := p_visibility;
begin
  select * into cur from recipes where id = p_id;
  if not found or cur.author_id is distinct from app_user_id() then
    raise exception 'recipe_not_found' using errcode = 'P0002';
  end if;
  if cur.copied_from is not null then
    select * into src from recipes where id = cur.copied_from;
    if found and visibility_rank(vis) > visibility_rank(src.visibility) then vis := src.visibility; end if;
  end if;
  update recipes set visibility = vis, updated_at = now() where id = p_id;
  return vis;
end $$;

-- -----------------------------------------------------------------------------
-- L'accueil. Classé par : cuisine aimée (+3), auteur suivi (+2), popularité
-- (log des copies), fraîcheur (-1 par mois). Ce que l'on ne mange pas n'y
-- apparaît jamais, ni ses propres recettes.
-- -----------------------------------------------------------------------------
create or replace function home_feed(p_limit int default 20, p_offset int default 0, p_kind text default 'all')
returns setof recipe_cards
language sql
stable
security invoker
as $$
  select rc.*
  from recipe_cards rc
  where rc.author_id is distinct from app_user_id()
    and rc.visibility <> 'private'
    and is_showcase(rc.copied_from, rc.modified_by_id, rc.author_id)
    and not (rc.dietary_flags && my_exclusions())
    and (p_kind = 'all' or (p_kind = 'video' and rc.has_video) or (p_kind = 'photo' and not rc.has_video))
  order by
    (  (exists (select 1 from profile_cuisines pc
                where pc.profile_id = app_user_id() and pc.cuisine_slug = rc.cuisine))::int * 3
     + (exists (select 1 from follows f
                where f.follower_id = app_user_id() and f.followee_id = rc.author_id))::int * 2
     + ln(1 + rc.copies_count) * 0.5
     - extract(epoch from (now() - rc.created_at)) / 86400.0 / 30.0
    ) desc,
    rc.created_at desc,
    rc.id
  limit least(greatest(p_limit, 1), 50) offset greatest(p_offset, 0);
$$;

-- -----------------------------------------------------------------------------
-- Les plus copiées. Fenêtres glissantes (24 h, 7 j, 30 j) : identiques pour
-- tous les fuseaux. Une personne compte une fois par recette, quel que soit
-- le nombre de copies qu'elle en fait.
-- -----------------------------------------------------------------------------
create or replace function trending_recipes(
  p_period       text,
  p_cuisine      text    default null,
  p_country      text    default null,
  p_respect_diet boolean default true,
  p_limit        int     default 30
)
returns table (rank int, period_copies int, recipe recipe_cards)
language plpgsql
stable
security definer
set search_path = public
as $$
declare
  span interval := case p_period
    when 'day'   then interval '1 day'
    when 'week'  then interval '7 days'
    when 'month' then interval '30 days'
  end;
begin
  if span is null then raise exception 'invalid_period' using errcode = '22023'; end if;

  return query
  with counts as (
    select rcp.source_id, count(distinct rcp.copier_id)::int as n
      from recipe_copies rcp
     where rcp.created_at > now() - span
     group by rcp.source_id
  )
  select (row_number() over (order by c.n desc, card.copies_count desc, card.id))::int,
         c.n,
         card
    from counts c
    join recipe_cards card on card.id = c.source_id
   -- security definer : la RLS ne s'applique pas ici, la règle est redite.
   where can_view_recipe(card.author_id, card.visibility)
     and card.visibility <> 'private'
     and (p_cuisine is null or card.cuisine = p_cuisine)
     and (p_country is null or card.country = p_country)
     and (not p_respect_diet or not (card.dietary_flags && my_exclusions()))
   order by 1
   limit least(greatest(p_limit, 1), 100);
end $$;

-- -----------------------------------------------------------------------------
-- Le Tour du monde : un point par pays, et ce qu'il porte.
-- -----------------------------------------------------------------------------
create or replace function globe_countries()
returns table (
  slug text, name_fr text, name_en text, flag text, lat double precision, lng double precision,
  cuisine text, continent text, recipe_count int
)
language sql
stable
security invoker
as $$
  select c.slug, c.name_fr, c.name_en, c.flag, c.lat, c.lng, c.cuisine, c.continent,
         count(r.id)::int
    from countries c
    left join recipes r
      on r.country = c.slug
     and r.visibility <> 'private'
     and is_showcase(r.copied_from, r.modified_by_id, r.author_id)
     and not (r.dietary_flags && my_exclusions())
   group by c.slug
   order by c.sort_order, c.slug;
$$;

create or replace function country_recipes(p_country text, p_limit int default 30, p_offset int default 0)
returns setof recipe_cards
language sql
stable
security invoker
as $$
  select rc.* from recipe_cards rc
   where rc.country = p_country
     and rc.visibility <> 'private'
     and is_showcase(rc.copied_from, rc.modified_by_id, rc.author_id)
     and not (rc.dietary_flags && my_exclusions())
   order by rc.copies_count desc, rc.created_at desc, rc.id
   limit least(greatest(p_limit, 1), 50) offset greatest(p_offset, 0);
$$;

-- -----------------------------------------------------------------------------
-- Profils
-- -----------------------------------------------------------------------------
create or replace function profile_summary(p_user uuid)
returns table (
  id uuid, username text, display_name text, bio text, avatar_url text, is_editorial boolean,
  followers int, following int, recipes int, is_following boolean, follows_me boolean, is_me boolean
)
language sql
stable
security invoker
as $$
  select p.id, p.username, p.display_name, p.bio, p.avatar_url, p.is_editorial,
         (select count(*)::int from follows where followee_id = p.id),
         (select count(*)::int from follows where follower_id = p.id),
         (select count(*)::int from recipes r where r.author_id = p.id),   -- RLS : celles que je vois
         exists (select 1 from follows where follower_id = app_user_id() and followee_id = p.id),
         exists (select 1 from follows where follower_id = p.id and followee_id = app_user_id()),
         p.id = app_user_id()
    from profiles p
   where p.id = p_user;
$$;

create or replace function user_recipes(p_user uuid, p_limit int default 50, p_offset int default 0)
returns setof recipe_cards
language sql
stable
security invoker
as $$
  select * from recipe_cards
   where author_id = p_user
   order by created_at desc, id
   limit least(greatest(p_limit, 1), 100) offset greatest(p_offset, 0);
$$;

create or replace function search_profiles(p_query text, p_limit int default 20)
returns setof profiles
language sql
stable
security invoker
as $$
  select * from profiles
   where refdata_norm(username || ' ' || display_name) like '%' || refdata_norm(p_query) || '%'
   order by is_editorial desc, username
   limit least(greatest(p_limit, 1), 50);
$$;

-- -----------------------------------------------------------------------------
-- Supprimer son compte (App Store 5.1.1(v), Google Play). Tout part en
-- cascade depuis le profil ; les copies que d'autres ont faites de mes
-- recettes restent à eux, et leur crédit devient « auteur supprimé ».
-- -----------------------------------------------------------------------------
create or replace function delete_my_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := app_user_id();
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  delete from profiles where id = me;
  if to_regclass('auth.users') is not null then
    execute 'delete from auth.users where id = $1' using me;
  end if;
end $$;

-- -----------------------------------------------------------------------------
-- Stockage des photos et vidéos : un dossier par utilisateur, lisible par tous
-- (les URL ne sont données qu'à qui peut voir la recette ; voir ETAT.md).
-- -----------------------------------------------------------------------------
do $$
begin
  if to_regclass('storage.buckets') is not null then
    insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    values ('recipe-media', 'recipe-media', true, 104857600,
            array['image/jpeg', 'image/png', 'image/webp', 'image/heic', 'video/mp4', 'video/quicktime'])
    on conflict (id) do nothing;

    execute $p$drop policy if exists recipe_media_upload on storage.objects$p$;
    execute $p$create policy recipe_media_upload on storage.objects for insert to authenticated
      with check (bucket_id = 'recipe-media' and (storage.foldername(name))[1] = auth.uid()::text)$p$;
    execute $p$drop policy if exists recipe_media_delete on storage.objects$p$;
    execute $p$create policy recipe_media_delete on storage.objects for delete to authenticated
      using (bucket_id = 'recipe-media' and (storage.foldername(name))[1] = auth.uid()::text)$p$;
  end if;
end $$;

-- -----------------------------------------------------------------------------
-- Droits. Supabase les pose d'office ; la base de test locale non.
-- -----------------------------------------------------------------------------
grant usage on schema public to anon, authenticated;
grant select on all tables in schema public to anon, authenticated;
grant insert, update, delete on profiles, profile_cuisines, profile_exclusions, recipes,
  recipe_ingredients, recipe_steps, recipe_media, follows, blocks, reports to authenticated;
grant execute on all functions in schema public to authenticated;
grant execute on function home_feed(int, int, text), trending_recipes(text, text, text, boolean, int),
  globe_countries(), country_recipes(text, int, int), profile_summary(uuid),
  user_recipes(uuid, int, int), search_profiles(text, int) to anon;
