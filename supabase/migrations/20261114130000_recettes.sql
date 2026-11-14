-- =============================================================================
-- couJina social — les recettes, leur confidentialité et leur attribution
--
-- Une recette appartient à son AUTEUR (author_id) : c'est sa copie, il en
-- choisit la confidentialité, il peut la modifier ou la supprimer. Quand elle
-- vient d'une autre, deux colonnes portent le crédit :
--
--   credit_author_id   le créateur d'origine, remonté le long de la chaîne
--   modified_by_id     qui a modifié la version que l'on lit (NULL si personne)
--
-- Affichage : « Recette de <credit> » ou « Recette de <credit> · modifiée par
-- <modified_by> ». Pour une recette écrite par son auteur, les deux sont NULL
-- et l'on affiche « Recette de <author> ». Les deux noms mènent au profil.
-- =============================================================================

do $$ begin
  create type recipe_visibility as enum ('public', 'followers', 'private');
exception when duplicate_object then null; end $$;

do $$ begin
  create type recipe_difficulty as enum ('easy', 'medium', 'hard');
exception when duplicate_object then null; end $$;

do $$ begin
  create type media_kind as enum ('photo', 'video');
exception when duplicate_object then null; end $$;

-- Rang d'ouverture : une copie ne peut pas être plus ouverte que sa source.
create or replace function visibility_rank(v recipe_visibility)
returns int language sql immutable as $$
  select case v when 'private' then 0 when 'followers' then 1 else 2 end;
$$;

create table if not exists recipes (
  id               uuid primary key default gen_random_uuid(),
  author_id        uuid not null references profiles(id) on delete cascade,
  slug             text unique,               -- le livre éditorial seulement
  title            text not null,
  native_name      text,
  description      text not null default '',
  cuisine          text references cuisines(slug),
  country          text references countries(slug),
  meal_type        text check (meal_type in ('main', 'starter', 'soup', 'salad', 'side', 'bread', 'dessert', 'drink')),
  difficulty       recipe_difficulty not null default 'medium',
  prep_min         int,
  cook_min         int,
  total_min        int generated always as (coalesce(prep_min, 0) + coalesce(cook_min, 0)) stored,
  servings         int not null default 4,
  lang             text not null default 'fr' check (lang in ('fr', 'en')),
  visibility       recipe_visibility not null default 'public',
  cover_url        text,
  video_url        text,
  -- Drapeaux des ingrédients NON facultatifs + ceux déclarés par l'auteur.
  dietary_flags    dietary_flag[] not null default '{}',
  declared_flags   dietary_flag[] not null default '{}',
  copied_from      uuid references recipes(id) on delete set null,
  credit_author_id uuid references profiles(id) on delete set null,
  modified_by_id   uuid references profiles(id) on delete set null,
  copies_count     int not null default 0,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  constraint recipes_title_length check (char_length(title) between 1 and 120),
  constraint recipes_description_length check (char_length(description) <= 2000),
  constraint recipes_times check (coalesce(prep_min, 0) >= 0 and coalesce(cook_min, 0) >= 0),
  constraint recipes_servings check (servings between 1 and 50)
);

create index if not exists recipes_author_idx  on recipes (author_id, created_at desc);
create index if not exists recipes_country_idx on recipes (country) where visibility = 'public';
create index if not exists recipes_cuisine_idx on recipes (cuisine, created_at desc);
create index if not exists recipes_copied_idx  on recipes (copied_from);

create table if not exists recipe_ingredients (
  recipe_id  uuid not null references recipes(id) on delete cascade,
  position   int  not null,
  raw        text not null,
  qty        numeric,
  unit       text,
  item       text not null default '',
  optional   boolean not null default false,
  group_name text,
  primary key (recipe_id, position)
);

create table if not exists recipe_steps (
  recipe_id uuid not null references recipes(id) on delete cascade,
  position  int  not null,
  body      text not null,
  minutes   int,
  primary key (recipe_id, position)
);

-- Les photos et les vidéos téléversées. `step_position` rattache une vidéo à
-- une étape ; NULL = média de la recette entière.
create table if not exists recipe_media (
  id            uuid primary key default gen_random_uuid(),
  recipe_id     uuid not null references recipes(id) on delete cascade,
  owner_id      uuid not null references profiles(id) on delete cascade,
  kind          media_kind not null,
  storage_path  text not null,
  public_url    text,
  step_position int,
  position      int not null default 0,
  duration_s    int,
  created_at    timestamptz not null default now()
);
create index if not exists recipe_media_recipe_idx on recipe_media (recipe_id, position);

-- -----------------------------------------------------------------------------
-- Les abonnements. Défini ici parce que la visibilité « abonnés » en dépend.
-- -----------------------------------------------------------------------------
create table if not exists follows (
  follower_id uuid not null references profiles(id) on delete cascade,
  followee_id uuid not null references profiles(id) on delete cascade,
  created_at  timestamptz not null default now(),
  primary key (follower_id, followee_id),
  constraint follows_not_self check (follower_id <> followee_id)
);
create index if not exists follows_followee_idx on follows (followee_id);

alter table follows enable row level security;
drop policy if exists follows_read on follows;
create policy follows_read on follows for select using (true);
drop policy if exists follows_insert_self on follows;
create policy follows_insert_self on follows for insert with check (follower_id = app_user_id());
drop policy if exists follows_delete_self on follows;
-- On peut se désabonner, et retirer un abonné.
create policy follows_delete_self on follows for delete
  using (follower_id = app_user_id() or followee_id = app_user_id());

-- -----------------------------------------------------------------------------
-- Qui voit quoi. Une seule règle, utilisée par toutes les policies.
-- security definer pour lire `follows` sans dépendre de sa propre RLS.
-- -----------------------------------------------------------------------------
create or replace function can_view_recipe(p_author uuid, p_visibility recipe_visibility)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select p_author = app_user_id()
      or p_visibility = 'public'
      or (p_visibility = 'followers'
          and exists (select 1 from follows
                      where follower_id = app_user_id() and followee_id = p_author));
$$;

alter table recipes            enable row level security;
alter table recipe_ingredients enable row level security;
alter table recipe_steps       enable row level security;
alter table recipe_media       enable row level security;

drop policy if exists recipes_read on recipes;
create policy recipes_read on recipes for select using (can_view_recipe(author_id, visibility));
drop policy if exists recipes_insert on recipes;
create policy recipes_insert on recipes for insert with check (author_id = app_user_id());
drop policy if exists recipes_update on recipes;
create policy recipes_update on recipes for update
  using (author_id = app_user_id()) with check (author_id = app_user_id());
drop policy if exists recipes_delete on recipes;
create policy recipes_delete on recipes for delete using (author_id = app_user_id());

-- Les lignes suivent leur recette.
drop policy if exists recipe_ingredients_read on recipe_ingredients;
create policy recipe_ingredients_read on recipe_ingredients for select
  using (exists (select 1 from recipes r where r.id = recipe_id));
drop policy if exists recipe_ingredients_write on recipe_ingredients;
create policy recipe_ingredients_write on recipe_ingredients for all
  using (exists (select 1 from recipes r where r.id = recipe_id and r.author_id = app_user_id()))
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.author_id = app_user_id()));

drop policy if exists recipe_steps_read on recipe_steps;
create policy recipe_steps_read on recipe_steps for select
  using (exists (select 1 from recipes r where r.id = recipe_id));
drop policy if exists recipe_steps_write on recipe_steps;
create policy recipe_steps_write on recipe_steps for all
  using (exists (select 1 from recipes r where r.id = recipe_id and r.author_id = app_user_id()))
  with check (exists (select 1 from recipes r where r.id = recipe_id and r.author_id = app_user_id()));

drop policy if exists recipe_media_read on recipe_media;
create policy recipe_media_read on recipe_media for select
  using (exists (select 1 from recipes r where r.id = recipe_id));
drop policy if exists recipe_media_write on recipe_media;
create policy recipe_media_write on recipe_media for all
  using (owner_id = app_user_id())
  with check (owner_id = app_user_id()
              and exists (select 1 from recipes r where r.id = recipe_id and r.author_id = app_user_id()));

-- -----------------------------------------------------------------------------
-- Les drapeaux d'une recette écrite à la main : chaque terme du référentiel
-- trouvé comme mot entier dans une ligne non facultative. Conservateur par
-- construction — « lait de coco » fait tomber « lait » —, et c'est voulu :
-- pour une allergie, cacher un plat de trop vaut mieux qu'un de moins.
-- -----------------------------------------------------------------------------
create or replace function detect_flags(p_lines text[])
returns dietary_flag[]
language sql
stable
as $$
  with l as (
    select ' ' || refdata_norm(line) || ' ' as plain,
           -- « lardons » -> « lardon » : le référentiel est au singulier.
           ' ' || regexp_replace(refdata_norm(line), '([a-z]{3,})[sx]\M', '\1', 'g') || ' ' as singular
      from unnest(coalesce(p_lines, '{}')) line
  )
  select coalesce(array_agg(distinct f order by f), '{}')
  from l
  join ingredient_terms t
    on l.plain like ('% ' || t.term_norm || ' %')
    or l.singular like ('% ' || t.term_norm || ' %')
  cross join lateral unnest(t.flags) f;
$$;

grant execute on function can_view_recipe(uuid, recipe_visibility), detect_flags(text[]),
  visibility_rank(recipe_visibility) to anon, authenticated;
