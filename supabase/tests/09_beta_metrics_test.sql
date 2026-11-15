-- La mesure du test à 20 cuisiniers (T-MES).
begin;

\echo '-- le rapport de la beta'
do $$
declare
  rows int;
  d1 text;
begin
  select count(*) into rows from beta_metrics();
  if rows < 7 then raise exception 'T-MES-01 : le rapport n''a que % lignes', rows; end if;
  select value into d1 from beta_metrics() where metric like 'Revenus le lendemain%';
  if d1 is null or d1 not like '% / 11' then raise exception 'T-MES-01 : J+1 attendu sur 11 testeurs, obtenu %', d1; end if;
  if not exists (select 1 from beta_metrics() where metric like 'Paierait %') then
    raise exception 'T-MES-04 : les réponses à la question du prix manquent au rapport';
  end if;
end $$;

set local role authenticated;
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom

\echo '-- une ouverture par demi-heure, et le refus respecte'
select track_event('app_open');
select track_event('app_open');
reset role;
do $$
begin
  if (select count(*) from app_events where profile_id = '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b') <> 1 then
    raise exception 'T-MES-02 : deux ouvertures en une minute ont compté deux fois';
  end if;
end $$;
update profiles set analytics_opt_out = true where id = '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b';
set local role authenticated;
select track_event('recipe_view');
reset role;
do $$
begin
  if exists (select 1 from app_events where profile_id = '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b' and name = 'recipe_view') then
    raise exception 'T-MES-03 : un évènement enregistré malgré le refus de la mesure';
  end if;
end $$;

set local role authenticated;
\echo '-- personne ne lit la mesure depuis l''app'
do $$
begin
  begin
    if exists (select 1 from app_events) then raise exception 'T-MES-05 : app_events lisible par un utilisateur'; end if;
  exception when insufficient_privilege then null;  -- encore mieux : la table est fermée
  end;
  begin
    perform beta_metrics();
    raise exception 'T-MES-05 : beta_metrics appelable par un utilisateur';
  exception when insufficient_privilege then null;
  end;
end $$;

\echo '-- la question du prix : une fois, a un prix fixe'
do $$
declare p int;
begin
  select price_cents into p from price_survey_due();
  if p not in (299, 399, 499) then raise exception 'T-MES-04 : prix inattendu %', p; end if;
  perform answer_price_survey('maybe', 'le mode hors ligne');
  perform answer_price_survey('yes', 'changé d''avis');
  if (select answer from price_survey where profile_id = app_user_id()) <> 'maybe' then
    raise exception 'T-MES-04 : la première réponse doit rester';
  end if;
  if (select due from price_survey_due()) then raise exception 'T-MES-04 : question reposée après réponse'; end if;
end $$;

rollback;
