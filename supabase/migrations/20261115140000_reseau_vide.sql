-- =============================================================================
-- couJina social — quoi faire quand le réseau est encore vide
--
-- Le Skeptic Shark : « quand personne ne copie rien le premier mois, qu'est-ce
-- qui fait revenir le deuxième jour ? ». Trois réponses, qui marchent dès la
-- première personne :
--
--   le défi de la semaine    un thème, qui change tout seul chaque lundi, et
--                            les recettes publiées pour lui
--   qui suivre               des cuisiniers qui aiment les mêmes cuisines
--   l'activité               « X a copié votre recette », « Y vous suit » :
--                            la raison la plus simple de rouvrir l'app
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Le défi de la semaine. Pas de calendrier à tenir : la semaine ISO choisit
-- le défi dans la liste, en boucle. Ajouter un défi = ajouter une ligne.
-- -----------------------------------------------------------------------------
create table if not exists challenges (
  id          uuid primary key default gen_random_uuid(),
  slug        text not null unique,
  position    int  not null unique,
  title       text not null,
  description text not null,
  cuisine     text references cuisines(slug)
);

alter table challenges enable row level security;
drop policy if exists challenges_read on challenges;
create policy challenges_read on challenges for select using (true);

alter table recipes add column if not exists challenge_id uuid references challenges(id) on delete set null;
alter table recipes add column if not exists challenge_week date;
create index if not exists recipes_challenge_idx on recipes (challenge_id, challenge_week);

/** Le lundi de la semaine en cours (heure de Paris : le public de lancement). */
create or replace function current_week_start()
returns date
language sql
stable
as $$
  select date_trunc('week', now() at time zone 'Europe/Paris')::date;
$$;

create or replace function current_challenge()
returns setof challenges
language sql
stable
as $$
  select c.* from challenges c
   where c.position = (
     select (array_agg(position order by position))[
              1 + (floor(extract(epoch from current_week_start()::timestamp) / 604800)::bigint
                   % greatest((select count(*) from challenges), 1))::int]
       from challenges);
$$;

/** Inscrire une de mes recettes au défi de cette semaine. */
create or replace function recipe_join_challenge(p_recipe uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  ch uuid := (select id from current_challenge());
begin
  if ch is null then raise exception 'no_challenge' using errcode = 'P0002'; end if;
  update recipes set challenge_id = ch, challenge_week = current_week_start()
   where id = p_recipe and author_id = app_user_id();
  if not found then raise exception 'recipe_not_found' using errcode = 'P0002'; end if;
end $$;

/** Les recettes du défi de cette semaine, les plus copiées d'abord. */
create or replace function challenge_entries(p_limit int default 30)
returns setof recipe_cards
language sql
stable
security invoker
as $$
  select rc.* from recipe_cards rc
    join recipes r on r.id = rc.id
   where r.challenge_id = (select id from current_challenge())
     and r.challenge_week = current_week_start()
     and rc.visibility <> 'private'
     and not (rc.dietary_flags && my_exclusions())
   order by rc.copies_count desc, rc.created_at desc
   limit least(greatest(p_limit, 1), 100);
$$;

-- -----------------------------------------------------------------------------
-- Qui suivre : des gens qui aiment les mêmes cuisines et qui publient.
-- -----------------------------------------------------------------------------
create or replace function who_to_follow(p_limit int default 10)
returns table (
  id uuid, username text, display_name text, avatar_url text, is_editorial boolean,
  shared_cuisines int, public_recipes int
)
language sql
stable
security definer
set search_path = public
as $$
  select p.id, p.username, p.display_name, p.avatar_url, p.is_editorial,
         (select count(*)::int from profile_cuisines a join profile_cuisines b using (cuisine_slug)
           where a.profile_id = app_user_id() and b.profile_id = p.id),
         (select count(*)::int from recipes r where r.author_id = p.id and r.visibility = 'public'
             and (r.copied_from is null or r.modified_by_id = r.author_id))
    from profiles p
   where p.id <> app_user_id()
     and not p.is_editorial
     and not exists (select 1 from follows f where f.follower_id = app_user_id() and f.followee_id = p.id)
     and not exists (select 1 from blocks b where (b.blocker_id = app_user_id() and b.blocked_id = p.id)
                                              or (b.blocker_id = p.id and b.blocked_id = app_user_id()))
   order by 6 desc, 7 desc, p.username
   limit least(greatest(p_limit, 1), 30);
$$;

-- -----------------------------------------------------------------------------
-- L'activité : ce qui m'est arrivé. Lue depuis les tables existantes, sans
-- table de notifications à remplir ; `activity_seen_at` dit ce qui est neuf.
-- -----------------------------------------------------------------------------
alter table profiles add column if not exists activity_seen_at timestamptz not null default now();

create or replace function my_activity(p_limit int default 50)
returns table (
  kind text, at timestamptz, actor_id uuid, actor_username text, actor_name text,
  recipe_id uuid, recipe_title text, is_new boolean
)
language sql
stable
security definer
set search_path = public
as $$
  with me as (select id, activity_seen_at from profiles where id = app_user_id()),
  items as (
    select 'follow'::text as kind, f.created_at as at, f.follower_id as actor, null::uuid as recipe
      from follows f, me where f.followee_id = me.id
    union all
    select case when x.modified then 'copy_modified' else 'copy' end, x.created_at, x.copier_id, x.source_id
      from recipe_copies x join recipes r on r.id = x.source_id, me
     where r.author_id = me.id and x.copier_id <> me.id
  )
  select i.kind, i.at, p.id, p.username, p.display_name, r.id, r.title, i.at > me.activity_seen_at
    from items i
    join profiles p on p.id = i.actor
    left join recipes r on r.id = i.recipe
    cross join me
   where not exists (select 1 from blocks b where (b.blocker_id = me.id and b.blocked_id = p.id)
                                              or (b.blocker_id = p.id and b.blocked_id = me.id))
   order by i.at desc
   limit least(greatest(p_limit, 1), 100);
$$;

create or replace function activity_unread()
returns int
language sql
stable
security definer
set search_path = public
as $$
  select count(*)::int from my_activity(100) where is_new;
$$;

create or replace function activity_mark_seen()
returns void
language sql
security definer
set search_path = public
as $$
  update profiles set activity_seen_at = now() where id = app_user_id();
$$;

/** Le profil derrière un lien d'invitation `coujinasocial://u/<username>`. */
create or replace function profile_by_username(p_username text)
returns uuid
language sql
stable
as $$
  select id from profiles where username = lower(p_username);
$$;

grant execute on function current_week_start(), current_challenge(), challenge_entries(int), who_to_follow(int),
  profile_by_username(text) to anon, authenticated;
grant execute on function recipe_join_challenge(uuid), my_activity(int), activity_unread(), activity_mark_seen()
  to authenticated;
grant select on challenges to anon, authenticated;
