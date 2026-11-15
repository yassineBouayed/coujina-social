-- =============================================================================
-- couJina social — conformité avant publication (2e passage du panel /shark)
--
--   1. Les CGU et l'âge : on n'entre qu'après avoir accepté la version en
--      vigueur des conditions et déclaré avoir 15 ans ou plus.
--   2. Les interdits alimentaires sont des données sensibles (RGPD, art. 9 :
--      « sans porc » peut révéler une religion, « sans arachides » une santé).
--      Ils ne sont enregistrés qu'après un consentement explicite, daté, et
--      retirable — le retrait les efface.
--   3. Signaler un « allergène manquant ».
--   4. La modération (DSA) : une file des signalements pour l'équipe, un
--      masquage motivé que l'auteur voit, et le compte rendu hebdomadaire des
--      opérations (signalements reçus, traités, délai).
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CGU et âge
-- -----------------------------------------------------------------------------
alter table profiles add column if not exists terms_version     text;
alter table profiles add column if not exists terms_accepted_at timestamptz;
alter table profiles add column if not exists age_confirmed_at  timestamptz;

/** La version des CGU et de la politique de confidentialité en vigueur. */
create or replace function current_terms_version()
returns text language sql immutable as $$ select '2026-11-15'::text; $$;

create or replace function accept_terms(p_version text, p_is_15_or_more boolean)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := app_user_id();
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  if p_version is distinct from current_terms_version() then
    raise exception 'terms_outdated' using errcode = '22023';
  end if;
  if not coalesce(p_is_15_or_more, false) then
    raise exception 'too_young' using errcode = '22023';
  end if;
  update profiles
     set terms_version = p_version, terms_accepted_at = now(),
         age_confirmed_at = coalesce(age_confirmed_at, now()), updated_at = now()
   where id = me;
end $$;

-- -----------------------------------------------------------------------------
-- 2. Consentement aux interdits alimentaires (art. 9.2.a du RGPD)
-- -----------------------------------------------------------------------------
alter table profiles add column if not exists diet_consent_at timestamptz;

create or replace function give_diet_consent()
returns void
language sql
security definer
set search_path = public
as $$
  update profiles set diet_consent_at = coalesce(diet_consent_at, now()), updated_at = now() where id = app_user_id();
$$;

/** Retirer son consentement efface les interdits : on ne garde pas ce qu'on n'a plus le droit de garder. */
create or replace function withdraw_diet_consent()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from profile_exclusions where profile_id = app_user_id();
  update profiles set diet_consent_at = null, updated_at = now() where id = app_user_id();
end $$;

-- Aucun interdit sans consentement, quelle que soit la porte (RPC ou écriture
-- directe) : la règle vit sur la table, pas dans l'écran.
create or replace function exclusions_require_consent()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if (select diet_consent_at from profiles where id = new.profile_id) is null then
    raise exception 'diet_consent_required' using errcode = '42501';
  end if;
  return new;
end $$;

drop trigger if exists profile_exclusions_consent on profile_exclusions;
create trigger profile_exclusions_consent
  before insert or update on profile_exclusions
  for each row execute function exclusions_require_consent();

-- -----------------------------------------------------------------------------
-- 3. Allergène manquant
-- -----------------------------------------------------------------------------
alter type report_reason add value if not exists 'allergen_missing';

-- -----------------------------------------------------------------------------
-- 4. Modération
-- -----------------------------------------------------------------------------
alter table profiles add column if not exists is_moderator boolean not null default false;

alter table recipes add column if not exists moderation_hidden_at timestamptz;
alter table recipes add column if not exists moderation_reason    text;

alter table reports add column if not exists resolved_at     timestamptz;
alter table reports add column if not exists resolved_by     uuid references profiles(id) on delete set null;
alter table reports add column if not exists resolution_note text not null default '';

-- Personne ne s'accorde lui-même le rôle de modérateur, ni ne se « dé-masque ».
revoke update on profiles from authenticated;
grant update (username, display_name, bio, avatar_url, lang, analytics_opt_out, updated_at) on profiles to authenticated;
-- onboarded_at n'est plus inscriptible en direct : le premier lancement l'écrit
-- avec ses propres droits, et ne touche jamais que les lignes de l'appelant.
alter function profile_onboard(text[], dietary_flag[]) security definer;
alter function profile_onboard(text[], dietary_flag[]) set search_path = public;
revoke update on recipes from authenticated;
grant update (title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min,
              servings, visibility, cover_url, video_url, declared_flags, updated_at) on recipes to authenticated;

-- Une recette masquée par la modération n'est plus visible que de son auteur.
drop policy if exists recipes_read on recipes;
create policy recipes_read on recipes for select
  using (can_view_recipe(author_id, visibility) and (moderation_hidden_at is null or author_id = app_user_id()));

-- On ne copie pas une recette masquée, ni telle quelle ni modifiée.
create or replace function block_copy_of_hidden()
returns trigger
language plpgsql
as $$
begin
  if new.copied_from is not null and exists (
       select 1 from recipes where id = new.copied_from and moderation_hidden_at is not null) then
    raise exception 'recipe_not_found' using errcode = 'P0002';
  end if;
  return new;
end $$;

drop trigger if exists recipes_block_hidden_copy on recipes;
create trigger recipes_block_hidden_copy
  before insert on recipes
  for each row execute function block_copy_of_hidden();

-- La carte porte l'état de modération : le classement (security definer) en a besoin.
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
  r.modified_by_id, mb.username as modified_username, mb.display_name as modified_name,
  r.cover_credit, r.cover_license, r.cover_source_url,
  r.moderation_hidden_at, r.moderation_reason
from recipes r
join profiles a on a.id = r.author_id
left join countries c on c.slug = r.country
left join profiles ca on ca.id = r.credit_author_id
left join profiles mb on mb.id = r.modified_by_id;

grant select on recipe_cards to anon, authenticated;

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
   -- security definer : la RLS ne s'applique pas ici, les règles sont redites.
   where can_view_recipe(card.author_id, card.visibility)
     and card.moderation_hidden_at is null
     and card.visibility <> 'private'
     and (p_cuisine is null or card.cuisine = p_cuisine)
     and (p_country is null or card.country = p_country)
     and (not p_respect_diet or not (card.dietary_flags && my_exclusions()))
   order by 1
   limit least(greatest(p_limit, 1), 100);
end $$;

create or replace function require_moderator()
returns void
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not coalesce((select is_moderator from profiles where id = app_user_id()), false) then
    raise exception 'not_moderator' using errcode = '42501';
  end if;
end $$;

/** Les signalements à traiter, les plus anciens d'abord, avec leur âge en heures. */
create or replace function moderation_queue()
returns table (
  report_id uuid, reason report_reason, details text, created_at timestamptz, age_hours int,
  recipe_id uuid, recipe_title text, recipe_author text, profile_id uuid, profile_username text,
  reporter_username text, open_reports_on_target int
)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  perform require_moderator();
  return query
  select r.id, r.reason, r.details, r.created_at,
         (extract(epoch from now() - r.created_at) / 3600)::int,
         rec.id, rec.title, ra.username, p.id, p.username, rp.username,
         (select count(*)::int from reports o where o.status = 'open'
            and (o.recipe_id = r.recipe_id or o.profile_id = r.profile_id))
    from reports r
    left join recipes rec on rec.id = r.recipe_id
    left join profiles ra on ra.id = rec.author_id
    left join profiles p on p.id = r.profile_id
    join profiles rp on rp.id = r.reporter_id
   where r.status = 'open'
   order by r.created_at;
end $$;

/**
 * Masquer une recette, avec un motif que son auteur lira (DSA, art. 17 :
 * l'exposé des motifs). Tous les signalements ouverts sur elle sont clos.
 */
create or replace function moderation_hide_recipe(p_recipe uuid, p_reason text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform require_moderator();
  if coalesce(btrim(p_reason), '') = '' then raise exception 'reason_required' using errcode = '22023'; end if;
  update recipes set moderation_hidden_at = now(), moderation_reason = btrim(p_reason) where id = p_recipe;
  if not found then raise exception 'recipe_not_found' using errcode = 'P0002'; end if;
  update reports set status = 'actioned', resolved_at = now(), resolved_by = app_user_id(), resolution_note = btrim(p_reason)
   where recipe_id = p_recipe and status = 'open';
end $$;

create or replace function moderation_restore_recipe(p_recipe uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform require_moderator();
  update recipes set moderation_hidden_at = null, moderation_reason = null where id = p_recipe;
end $$;

create or replace function moderation_dismiss(p_report uuid, p_note text default '')
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform require_moderator();
  update reports set status = 'dismissed', resolved_at = now(), resolved_by = app_user_id(),
                     resolution_note = coalesce(p_note, '')
   where id = p_report and status = 'open';
  if not found then raise exception 'report_not_found' using errcode = 'P0002'; end if;
end $$;

/**
 * La feuille d'opérations de l'Operator Shark, semaine par semaine : combien
 * de signalements reçus, traités, en combien d'heures, et combien sous 24 h.
 */
create or replace function ops_weekly(p_weeks int default 8)
returns table (
  week_start date, received int, resolved int, still_open int,
  median_hours numeric, within_24h int, hidden_recipes int
)
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  perform require_moderator();
  return query
  with weeks as (
    select generate_series(current_week_start() - 7 * (greatest(p_weeks, 1) - 1), current_week_start(), interval '7 days')::date as w
  )
  select w.w,
         (select count(*)::int from reports r where r.created_at >= w.w and r.created_at < w.w + 7),
         (select count(*)::int from reports r where r.resolved_at >= w.w and r.resolved_at < w.w + 7),
         (select count(*)::int from reports r where r.created_at < w.w + 7 and (r.resolved_at is null or r.resolved_at >= w.w + 7)),
         (select round((percentile_cont(0.5) within group (order by extract(epoch from r.resolved_at - r.created_at) / 3600))::numeric, 1)
            from reports r where r.resolved_at >= w.w and r.resolved_at < w.w + 7),
         (select count(*)::int from reports r where r.resolved_at >= w.w and r.resolved_at < w.w + 7
             and r.resolved_at - r.created_at <= interval '24 hours'),
         (select count(*)::int from recipes x where x.moderation_hidden_at >= w.w and x.moderation_hidden_at < w.w + 7)
    from weeks w
   order by w.w desc;
end $$;

grant execute on function current_terms_version(), accept_terms(text, boolean), give_diet_consent(),
  withdraw_diet_consent(), moderation_queue(), moderation_hide_recipe(uuid, text), moderation_restore_recipe(uuid),
  moderation_dismiss(uuid, text), ops_weekly(int) to authenticated;
