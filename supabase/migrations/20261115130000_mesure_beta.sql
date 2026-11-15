-- =============================================================================
-- couJina social — mesurer le test à 20 cuisiniers
--
-- Les requins ont demandé quatre chiffres, sur de vrais téléphones :
--   combien PUBLIENT une recette, combien SUIVENT quelqu'un,
--   combien REVIENNENT le lendemain et la semaine suivante,
--   combien acceptent de PAYER un prix fixé.
--
-- Les deux premiers se lisent déjà dans recipes, recipe_copies et follows,
-- tous datés. Il manquait les ouvertures de l'application (pour la
-- rétention) et une question de prix. C'est tout ce que cette migration
-- ajoute : pas de traceur tiers, pas de navigation enregistrée écran par
-- écran, et un refus possible depuis le profil.
-- =============================================================================

alter table profiles add column if not exists analytics_opt_out boolean not null default false;

-- Les seuls évènements enregistrés. Une liste fermée, pour qu'on ne
-- glisse pas vers « on enregistre tout au cas où ».
do $$ begin
  create type app_event_name as enum ('app_open', 'recipe_view', 'video_play', 'share_invite');
exception when duplicate_object then null; end $$;

create table if not exists app_events (
  id         bigint generated always as identity primary key,
  profile_id uuid not null references profiles(id) on delete cascade,
  name       app_event_name not null,
  recipe_id  uuid references recipes(id) on delete set null,
  created_at timestamptz not null default now()
);
create index if not exists app_events_profile_idx on app_events (profile_id, created_at);

alter table app_events enable row level security;
-- Personne ne lit les évènements depuis l'application, pas même les siens :
-- seul le rapport de la bêta (beta_metrics, réservé à l'équipe) les compte.
drop policy if exists app_events_none on app_events;
create policy app_events_none on app_events for select using (false);

create or replace function track_event(p_name app_event_name, p_recipe uuid default null)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := app_user_id();
begin
  if me is null then return; end if;
  if (select analytics_opt_out from profiles where id = me) then return; end if;
  -- Une ouverture toutes les 30 minutes au plus : on mesure des visites, pas des réveils d'écran.
  if p_name = 'app_open' and exists (
       select 1 from app_events where profile_id = me and name = 'app_open' and created_at > now() - interval '30 minutes') then
    return;
  end if;
  insert into app_events (profile_id, name, recipe_id) values (me, p_name, p_recipe);
end $$;

-- -----------------------------------------------------------------------------
-- La question du prix : posée une fois, à un prix fixé d'avance pour chaque
-- personne (trois prix tirés du compte, pour voir où la réponse bascule).
-- -----------------------------------------------------------------------------
do $$ begin
  create type price_answer as enum ('yes', 'maybe', 'no');
exception when duplicate_object then null; end $$;

create table if not exists price_survey (
  profile_id  uuid primary key references profiles(id) on delete cascade,
  price_cents int not null check (price_cents in (299, 399, 499)),
  answer      price_answer not null,
  wants       text not null default '' check (char_length(wants) <= 500),
  created_at  timestamptz not null default now()
);

alter table price_survey enable row level security;
drop policy if exists price_survey_self on price_survey;
create policy price_survey_self on price_survey for select using (profile_id = app_user_id());

/** Le prix montré à cette personne : toujours le même pour elle. */
create or replace function survey_price(p_profile uuid)
returns int
language sql
immutable
as $$
  select (array[299, 399, 499])[1 + abs(hashtext(p_profile::text)) % 3];
$$;

create or replace function answer_price_survey(p_answer price_answer, p_wants text default '')
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := app_user_id();
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  insert into price_survey (profile_id, price_cents, answer, wants)
  values (me, survey_price(me), p_answer, left(coalesce(p_wants, ''), 500))
  on conflict (profile_id) do nothing;
end $$;

/**
 * Faut-il poser la question ? Après trois jours d'usage distincts, une seule
 * fois. Avant, la personne ne sait pas encore ce qu'elle paierait.
 */
create or replace function price_survey_due()
returns table (due boolean, price_cents int)
language sql
stable
security definer
set search_path = public
as $$
  select not exists (select 1 from price_survey where profile_id = app_user_id())
         and (select count(distinct created_at::date) from app_events
               where profile_id = app_user_id() and name = 'app_open') >= 3,
         survey_price(app_user_id());
$$;

-- -----------------------------------------------------------------------------
-- La cohorte de la bêta, et ses chiffres.
-- -----------------------------------------------------------------------------
create table if not exists beta_testers (
  profile_id uuid primary key references profiles(id) on delete cascade,
  joined_on  date not null default current_date,
  note       text not null default ''
);
alter table beta_testers enable row level security;
-- Aucune policy : seule l'équipe (service_role / postgres) lit et écrit la cohorte.

/**
 * Les chiffres demandés par les requins, pour la cohorte. Réservé à l'équipe :
 * appelé par `npm run beta:report` avec la clé de la base, jamais depuis
 * l'application.
 *
 * Rétention à J+1 : parmi ceux qui ont au moins J+1 d'ancienneté, part qui a
 * ouvert l'application le lendemain de son premier jour. Idem J+7 (entre le
 * 7e et le 13e jour, la définition courante de « la semaine suivante »).
 */
create or replace function beta_metrics()
returns table (metric text, value text, detail text)
language sql
stable
security definer
set search_path = public
as $$
  with cohort as (
    select b.profile_id, b.joined_on,
           (select min(created_at)::date from app_events e where e.profile_id = b.profile_id and e.name = 'app_open') as first_day
      from beta_testers b
  ),
  base as (
    select c.*,
      exists (select 1 from app_events e where e.profile_id = c.profile_id and e.name = 'app_open') as opened,
      exists (select 1 from recipes r where r.author_id = c.profile_id and (r.copied_from is null or r.modified_by_id = r.author_id)) as posted,
      exists (select 1 from recipe_copies x where x.copier_id = c.profile_id) as copied,
      exists (select 1 from follows f where f.follower_id = c.profile_id) as followed,
      exists (select 1 from app_events e where e.profile_id = c.profile_id and e.name = 'app_open'
              and e.created_at::date = c.first_day + 1) as d1,
      exists (select 1 from app_events e where e.profile_id = c.profile_id and e.name = 'app_open'
              and e.created_at::date between c.first_day + 7 and c.first_day + 13) as d7,
      c.first_day <= current_date - 1 as d1_eligible,
      c.first_day <= current_date - 13 as d7_eligible
    from cohort c
  ),
  pct as (
    select
      count(*) as n,
      count(*) filter (where opened) as opened,
      count(*) filter (where posted) as posted,
      count(*) filter (where copied) as copied,
      count(*) filter (where followed) as followed,
      count(*) filter (where d1_eligible) as d1_base, count(*) filter (where d1_eligible and d1) as d1,
      count(*) filter (where d7_eligible) as d7_base, count(*) filter (where d7_eligible and d7) as d7
    from base
  )
  select 'Testeurs', n::text, 'dans beta_testers' from pct
  union all select 'Ont ouvert l''app', opened || ' / ' || n, null from pct
  union all select 'Ont publié une recette', posted || ' / ' || n, 'écrite ou copiée avec modifications' from pct
  union all select 'Ont enregistré une recette', copied || ' / ' || n, null from pct
  union all select 'Suivent quelqu''un', followed || ' / ' || n, null from pct
  union all select 'Revenus le lendemain (J+1)', d1 || ' / ' || d1_base,
                   case when d1_base > 0 then round(100.0 * d1 / d1_base) || ' %' end from pct
  union all select 'Revenus la semaine suivante (J+7 à J+13)', d7 || ' / ' || d7_base,
                   case when d7_base > 0 then round(100.0 * d7 / d7_base) || ' %' else 'pas encore mesurable' end from pct
  union all
  select 'Paierait ' || to_char(s.price_cents / 100.0, 'FM0D00') || ' €/mois',
         count(*) filter (where s.answer = 'yes') || ' oui · ' || count(*) filter (where s.answer = 'maybe') || ' peut-être · '
           || count(*) filter (where s.answer = 'no') || ' non',
         null
    from price_survey s join beta_testers b on b.profile_id = s.profile_id
   group by s.price_cents;
$$;

revoke all on function beta_metrics() from public, anon, authenticated;
grant execute on function track_event(app_event_name, uuid), answer_price_survey(price_answer, text),
  price_survey_due() to authenticated;
grant select on price_survey to authenticated;
grant update (analytics_opt_out) on profiles to authenticated;
