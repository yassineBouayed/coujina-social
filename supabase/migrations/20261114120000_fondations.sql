-- =============================================================================
-- couJina social — fondations
--
-- Les comptes, les référentiels (cuisines, pays, régimes) et les préférences
-- posées au premier lancement : les cuisines aimées, puis ce que l'on ne mange
-- pas. Repris de l'ancien projet : app_user_id(), refdata_norm(), les cuisines
-- et les pays. Nouveau : le profil est PERSONNEL (plus de foyer), public, et
-- porte un nom d'utilisateur unique.
-- =============================================================================

create extension if not exists pgcrypto;

-- -----------------------------------------------------------------------------
-- L'utilisateur courant, lu dans le JWT. NULL hors session.
-- Repris tel quel de l'ancien projet : les tests locaux le pilotent avec
-- `set local request.jwt.claims`, Supabase le remplit en production.
-- -----------------------------------------------------------------------------
create or replace function app_user_id()
returns uuid
language sql
stable
as $$
  select nullif(
    coalesce(
      nullif(current_setting('request.jwt.claim.sub', true), ''),
      nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub'
    ),
    ''
  )::uuid;
$$;

-- Minuscules, sans accents, sans ponctuation. Miroir de norm() dans
-- tools/refdata/refdata.mjs : les deux doivent rester identiques.
create or replace function refdata_norm(p_text text)
returns text
language sql
immutable
strict
parallel safe
as $$
  select btrim(
    regexp_replace(
      regexp_replace(
        translate(
          replace(replace(lower(p_text), U&'\0153', 'oe'), U&'\00E6', 'ae'),
          U&'\00E0\00E1\00E2\00E3\00E4\00E5\00E7\00E8\00E9\00EA\00EB\00EC\00ED\00EE\00EF\00F1\00F2\00F3\00F4\00F5\00F6\00F9\00FA\00FB\00FC\00FD\00FF',
          'aaaaaaceeeeiiiinooooouuuuyy'
        ),
        '[^a-z0-9]+', ' ', 'g'
      ),
      '\s+', ' ', 'g'
    )
  );
$$;

-- -----------------------------------------------------------------------------
-- Référentiels, lisibles par tous, écrits par l'amorçage seulement.
-- -----------------------------------------------------------------------------
create table if not exists cuisines (
  slug          text primary key,
  name_fr       text not null,
  name_en       text not null,
  sort_order    int  not null default 0,
  gradient_from text not null default '#C65A1A',
  gradient_to   text not null default '#7A2E1E'
);

create table if not exists continents (
  slug       text primary key,
  name_fr    text not null,
  name_en    text not null,
  sort_order int  not null default 0
);

-- lat / lng : le point où le globe de « Tour du monde » plante l'épingle.
create table if not exists countries (
  slug       text primary key,
  name_fr    text not null,
  name_en    text not null,
  cuisine    text not null references cuisines(slug),
  continent  text not null references continents(slug),
  flag       text not null default '',
  lat        double precision not null,
  lng        double precision not null,
  sort_order int not null default 0,
  constraint countries_lat check (lat between -90 and 90),
  constraint countries_lng check (lng between -180 and 180)
);

-- Ce que l'on peut ne pas manger. `meat` est nouveau : il descend des
-- catégories viandes / volailles / charcuterie du référentiel, et c'est lui
-- qui rend possible « végétarien ».
do $$ begin
  create type dietary_flag as enum (
    'meat', 'pork', 'alcohol', 'gluten', 'peanut', 'tree_nut', 'dairy', 'egg', 'fish', 'shellfish'
  );
exception when duplicate_object then null; end $$;

-- Les termes du référentiel d'ingrédients et les drapeaux qu'ils portent :
-- c'est avec eux qu'une recette écrite par un utilisateur hérite de ses
-- drapeaux (detect_flags, plus bas).
create table if not exists ingredient_terms (
  term_norm text primary key,
  flags     dietary_flag[] not null default '{}'
);

alter table cuisines         enable row level security;
alter table continents       enable row level security;
alter table countries        enable row level security;
alter table ingredient_terms enable row level security;

drop policy if exists cuisines_read on cuisines;
create policy cuisines_read on cuisines for select using (true);
drop policy if exists continents_read on continents;
create policy continents_read on continents for select using (true);
drop policy if exists countries_read on countries;
create policy countries_read on countries for select using (true);
drop policy if exists ingredient_terms_read on ingredient_terms;
create policy ingredient_terms_read on ingredient_terms for select using (true);

-- -----------------------------------------------------------------------------
-- Profils : un par compte, publics (nom, avatar, bio). L'e-mail n'y est pas :
-- il reste dans auth.users, que personne d'autre ne lit.
-- -----------------------------------------------------------------------------
create table if not exists profiles (
  id            uuid primary key,
  username      text not null unique,
  display_name  text not null default '',
  bio           text not null default '',
  avatar_url    text,
  lang          text check (lang in ('fr', 'en')),
  -- NULL tant que les deux questions du premier lancement n'ont pas reçu de
  -- réponse. « Aucune contrainte » est une réponse, et elle remplit ce champ.
  onboarded_at  timestamptz,
  -- Comptes éditoriaux (le livre de couJina) : pas de connexion possible,
  -- affichés avec un badge.
  is_editorial  boolean not null default false,
  created_at    timestamptz not null default now(),
  updated_at    timestamptz not null default now(),

  constraint profiles_username_format check (username ~ '^[a-z0-9_.]{3,30}$'),
  constraint profiles_display_name_length check (char_length(display_name) <= 60),
  constraint profiles_bio_length check (char_length(bio) <= 280)
);

-- Pas de clé étrangère vers auth.users : les comptes éditoriaux (le livre de
-- couJina) et les comptes fictifs de démonstration n'y existent pas. La
-- suppression d'un compte efface son profil par le déclencheur
-- on_auth_user_deleted, plus bas, et tout le reste suit en cascade.

create table if not exists profile_cuisines (
  profile_id   uuid not null references profiles(id) on delete cascade,
  cuisine_slug text not null references cuisines(slug),
  primary key (profile_id, cuisine_slug)
);

create table if not exists profile_exclusions (
  profile_id uuid not null references profiles(id) on delete cascade,
  flag       dietary_flag not null,
  primary key (profile_id, flag)
);

alter table profiles           enable row level security;
alter table profile_cuisines   enable row level security;
alter table profile_exclusions enable row level security;

drop policy if exists profiles_read on profiles;
create policy profiles_read on profiles for select using (true);
drop policy if exists profiles_update_self on profiles;
create policy profiles_update_self on profiles for update
  using (id = app_user_id()) with check (id = app_user_id() and is_editorial = false);

-- Les préférences ne regardent que leur propriétaire.
drop policy if exists profile_cuisines_self on profile_cuisines;
create policy profile_cuisines_self on profile_cuisines for all
  using (profile_id = app_user_id()) with check (profile_id = app_user_id());
drop policy if exists profile_exclusions_self on profile_exclusions;
create policy profile_exclusions_self on profile_exclusions for all
  using (profile_id = app_user_id()) with check (profile_id = app_user_id());

-- -----------------------------------------------------------------------------
-- Un nom d'utilisateur libre, tiré de l'e-mail ou du nom Google.
-- -----------------------------------------------------------------------------
create or replace function suggest_username(p_seed text)
returns text
language plpgsql
volatile
as $$
declare
  base text := left(regexp_replace(refdata_norm(coalesce(p_seed, '')), '[^a-z0-9]+', '', 'g'), 20);
  candidate text;
  n int := 0;
begin
  if char_length(base) < 3 then base := 'cuisinier'; end if;
  candidate := base;
  while exists (select 1 from profiles where username = candidate) loop
    n := n + 1;
    candidate := base || n::text;
  end loop;
  return candidate;
end $$;

-- Le profil naît avec le compte, quelle que soit la porte (mot de passe,
-- Google, Apple).
create or replace function handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  meta jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  shown text := coalesce(meta ->> 'full_name', meta ->> 'name', split_part(new.email, '@', 1), '');
begin
  insert into profiles (id, username, display_name, avatar_url)
  values (
    new.id,
    suggest_username(coalesce(meta ->> 'username', split_part(new.email, '@', 1))),
    left(shown, 60),
    meta ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end $$;

create or replace function handle_deleted_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from profiles where id = old.id;
  return old;
end $$;

do $$
begin
  if to_regclass('auth.users') is not null then
    drop trigger if exists on_auth_user_created on auth.users;
    create trigger on_auth_user_created
      after insert on auth.users
      for each row execute function handle_new_user();
    drop trigger if exists on_auth_user_deleted on auth.users;
    create trigger on_auth_user_deleted
      after delete on auth.users
      for each row execute function handle_deleted_user();
  end if;
end $$;

-- -----------------------------------------------------------------------------
-- Le premier lancement : les cuisines, puis ce que l'on ne mange pas.
-- Un seul appel pour les deux réponses : entre deux écritures, l'accueil
-- montrerait des plats que la personne ne doit pas voir.
-- -----------------------------------------------------------------------------
create or replace function profile_onboard(p_cuisines text[], p_exclusions dietary_flag[])
returns void
language plpgsql
security invoker
as $$
declare
  me uuid := app_user_id();
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;

  delete from profile_cuisines where profile_id = me;
  insert into profile_cuisines (profile_id, cuisine_slug)
    select me, c from unnest(coalesce(p_cuisines, '{}')) c on conflict do nothing;

  delete from profile_exclusions where profile_id = me;
  insert into profile_exclusions (profile_id, flag)
    select me, f from unnest(coalesce(p_exclusions, '{}')) f on conflict do nothing;

  update profiles set onboarded_at = coalesce(onboarded_at, now()), updated_at = now() where id = me;
end $$;

-- Mêmes réponses, modifiées depuis « Mon profil ».
create or replace function profile_set_preferences(p_cuisines text[], p_exclusions dietary_flag[])
returns void
language sql
security invoker
as $$
  select profile_onboard(p_cuisines, p_exclusions);
$$;

create or replace function my_exclusions()
returns dietary_flag[]
language sql
stable
as $$
  select coalesce(array_agg(flag), '{}') from profile_exclusions where profile_id = app_user_id();
$$;

grant execute on function app_user_id(), refdata_norm(text), my_exclusions() to anon, authenticated;
grant execute on function profile_onboard(text[], dietary_flag[]),
                          profile_set_preferences(text[], dietary_flag[]) to authenticated;
