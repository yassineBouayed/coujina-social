-- =============================================================================
-- couJina social — 3e passage du panel /shark : l'argent réel, et la sécurité
--
--   1. Le livre de famille se vend À L'ANNÉE (29 € par famille et par an), pas
--      au mois : « pourquoi payer chaque mois un livre qu'on imprime une
--      fois ? ». La question du prix teste 19 / 29 / 39 € par an.
--   2. Pendant la bêta, un essai de 30 jours, puis une PRÉCOMMANDE payée par
--      un lien Stripe. Le paiement arrive par la fonction `stripe-webhook` et
--      prolonge le Premium d'un an. Le rapport de bêta compte les familles qui
--      ont VRAIMENT payé, et celles qui ont payé après avoir exporté leur livre.
--   3. Un signalement « allergène manquant » masque la recette TOUT DE SUITE,
--      jusqu'à vérification : la sécurité passe avant le délai de 24 h.
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. Les prix testés, à l'année
-- -----------------------------------------------------------------------------
alter table price_survey drop constraint if exists price_survey_price_cents_check;
alter table price_survey add constraint price_survey_price_cents_check
  check (price_cents in (299, 399, 499, 1900, 2900, 3900));
alter table price_survey add column if not exists period text not null default 'month' check (period in ('month', 'year'));
alter table price_survey alter column period set default 'year';

/** Le prix annuel montré à cette personne : toujours le même pour elle. */
create or replace function survey_price(p_profile uuid)
returns int
language sql
immutable
as $$
  select (array[1900, 2900, 3900])[1 + abs(hashtext(p_profile::text)) % 3];
$$;

-- -----------------------------------------------------------------------------
-- 2. Essai et précommande
-- -----------------------------------------------------------------------------
-- (les évènements family_export et premium_view : migration 20261117110000,
-- une valeur d'énumération ne s'utilise pas dans la transaction qui la crée.)

alter table profiles add column if not exists trial_until timestamptz;

create table if not exists preorders (
  id                uuid primary key default gen_random_uuid(),
  profile_id        uuid not null references profiles(id) on delete cascade,
  stripe_session_id text not null unique,
  amount_cents      int not null check (amount_cents > 0),
  currency          text not null default 'eur',
  status            text not null default 'paid' check (status in ('paid', 'refunded')),
  paid_at           timestamptz not null default now()
);
alter table preorders enable row level security;
drop policy if exists preorders_self on preorders;
create policy preorders_self on preorders for select using (profile_id = app_user_id());
grant select on preorders to authenticated;

-- Le Premium vaut pendant l'essai ou après un paiement.
create or replace function is_premium(p_profile uuid default null)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select greatest(premium_until, trial_until) > now()
                     from profiles where id = coalesce(p_profile, app_user_id())), false);
$$;

/** L'équipe ouvre l'essai d'un testeur (30 jours par défaut). */
create or replace function start_trial(p_profile uuid, p_days int default 30)
returns void
language sql
security definer
set search_path = public
as $$
  update profiles set trial_until = now() + make_interval(days => greatest(p_days, 1)) where id = p_profile;
$$;

/**
 * Un paiement Stripe confirmé. Appelée par la fonction `stripe-webhook` avec la
 * clé de service, jamais depuis l'application. Idempotente : Stripe renvoie
 * parfois deux fois le même évènement.
 */
create or replace function record_preorder_payment(p_profile uuid, p_session text, p_amount_cents int, p_currency text default 'eur')
returns boolean
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (select 1 from profiles where id = p_profile) then
    raise exception 'profile_not_found' using errcode = 'P0002';
  end if;
  insert into preorders (profile_id, stripe_session_id, amount_cents, currency)
  values (p_profile, p_session, p_amount_cents, lower(coalesce(p_currency, 'eur')))
  on conflict (stripe_session_id) do nothing;
  if not found then return false; end if;
  update profiles
     set premium_until = greatest(coalesce(premium_until, now()), coalesce(trial_until, now()), now()) + interval '1 year'
   where id = p_profile;
  return true;
end $$;

revoke all on function record_preorder_payment(uuid, text, int, text) from public, anon, authenticated;
revoke all on function start_trial(uuid, int) from public, anon, authenticated;

/**
 * L'argent réel de la bêta, pour `npm run beta:report` (équipe seulement) :
 * familles qui ont exporté leur livre, qui ont payé, qui ont payé APRÈS un
 * export ; qui saisit les recettes ; en combien de temps arrive la première.
 */
create or replace function beta_money_metrics()
returns table (metric text, value text, detail text)
language sql
stable
security definer
set search_path = public
as $$
  with cohort as (select profile_id from beta_testers),
  exported as (
    select distinct e.profile_id, min(e.created_at) over (partition by e.profile_id) as first_export
      from app_events e join cohort c using (profile_id) where e.name = 'family_export'
  ),
  paid as (
    select distinct p.profile_id, min(p.paid_at) over (partition by p.profile_id) as first_paid
      from preorders p join cohort c using (profile_id) where p.status = 'paid'
  ),
  books as (
    select b.id, b.created_at,
           (select min(fr.added_at) from family_recipes fr where fr.book_id = b.id) as first_recipe
      from family_books b join cohort c on c.profile_id = b.owner_id
  ),
  adders as (
    select fr.added_by = b.owner_id as by_owner, count(*) as n
      from family_recipes fr join family_books b on b.id = fr.book_id join cohort c on c.profile_id = b.owner_id
     group by 1
  )
  select 'Livres de famille créés', (select count(*) from books)::text, null
  union all select 'Ont exporté leur livre', (select count(*) from exported)::text || ' / ' || (select count(*) from cohort), null
  union all select 'Ont payé (précommande)', (select count(*) from paid)::text || ' / ' || (select count(*) from cohort),
                   (select coalesce(sum(amount_cents), 0) / 100 || ' € encaissés' from preorders p join cohort c using (profile_id) where p.status = 'paid')
  union all select 'Ont payé après un export', (select count(*) from paid p join exported e using (profile_id) where p.first_paid >= e.first_export)::text, 'la preuve demandée par le Customer Shark'
  union all select 'Délai médian création du livre → 1re recette',
                   coalesce((select round((percentile_cont(0.5) within group (order by extract(epoch from first_recipe - created_at) / 3600))::numeric, 1)::text || ' h'
                               from books where first_recipe is not null), '—'),
                   'qui saisit, et en combien de temps'
  union all select 'Recettes rangées par le créateur / par la famille',
                   coalesce((select n from adders where by_owner), 0) || ' / ' || coalesce((select n from adders where not by_owner), 0), null;
$$;

revoke all on function beta_money_metrics() from public, anon, authenticated;

-- -----------------------------------------------------------------------------
-- 3. Allergène manquant : masquage immédiat, jusqu'à vérification
-- -----------------------------------------------------------------------------
alter table recipes add column if not exists moderation_auto boolean not null default false;

create or replace function auto_hide_on_allergen_report()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.reason <> 'allergen_missing' or new.recipe_id is null then return new; end if;
  -- Contre l'abus (signaler pour nuire) : au-delà de 5 signalements « allergène »
  -- par jour, ceux d'une même personne attendent la file normale.
  if (select count(*) from reports where reporter_id = new.reporter_id and reason = 'allergen_missing'
        and created_at > now() - interval '24 hours') > 5 then
    return new;
  end if;
  update recipes
     set moderation_hidden_at = now(),
         moderation_reason = 'Masquée par précaution : un allergène manquant a été signalé. Vérification en cours.',
         moderation_auto = true
   where id = new.recipe_id and moderation_hidden_at is null;
  return new;
end $$;

drop trigger if exists reports_allergen_auto_hide on reports;
create trigger reports_allergen_auto_hide after insert on reports
  for each row execute function auto_hide_on_allergen_report();

-- Classer un signalement « allergène » à tort rend la recette, s'il n'en reste pas d'autre.
create or replace function moderation_dismiss(p_report uuid, p_note text default '')
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  rid uuid;
begin
  perform require_moderator();
  update reports set status = 'dismissed', resolved_at = now(), resolved_by = app_user_id(),
                     resolution_note = coalesce(p_note, '')
   where id = p_report and status = 'open'
   returning recipe_id into rid;
  if not found then raise exception 'report_not_found' using errcode = 'P0002'; end if;
  if rid is not null and not exists (select 1 from reports where recipe_id = rid and status = 'open' and reason = 'allergen_missing') then
    update recipes set moderation_hidden_at = null, moderation_reason = null, moderation_auto = false
     where id = rid and moderation_auto;
  end if;
end $$;

-- Un masquage décidé par un modérateur n'est plus « automatique ».
create or replace function moderation_hide_recipe(p_recipe uuid, p_reason text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform require_moderator();
  if coalesce(btrim(p_reason), '') = '' then raise exception 'reason_required' using errcode = '22023'; end if;
  update recipes set moderation_hidden_at = now(), moderation_reason = btrim(p_reason), moderation_auto = false where id = p_recipe;
  if not found then raise exception 'recipe_not_found' using errcode = 'P0002'; end if;
  update reports set status = 'actioned', resolved_at = now(), resolved_by = app_user_id(), resolution_note = btrim(p_reason)
   where recipe_id = p_recipe and status = 'open';
end $$;
