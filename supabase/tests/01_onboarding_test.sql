-- Premier lancement : les cuisines, puis ce que l'on ne mange pas (plan de test T-ONB).
--   Tom (compte neuf) n'est pas encore passé par l'onboarding ;
--   profile_onboard() enregistre les deux réponses d'un coup ;
--   personne ne peut écrire les préférences d'un autre.
begin;

\echo '-- onboarding'
set local role authenticated;
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom

do $$
begin
  if (select onboarded_at from profiles where id = app_user_id()) is not null then
    raise exception 'T-ONB-01 : Tom ne devrait pas encore être passé par le premier lancement';
  end if;
  if (select count(*) from profile_cuisines) <> 0 then
    raise exception 'T-ONB-01 : Tom ne devrait avoir aucune cuisine';
  end if;
end $$;

\echo '-- CGU, age, consentement aux interdits (RGPD art. 9)'
do $$
begin
  begin
    perform accept_terms(current_terms_version(), false);
    raise exception 'T-LEG-02 : un compte de moins de 15 ans a été accepté';
  exception when invalid_parameter_value then null;
  end;
  begin
    perform accept_terms('2020-01-01', true);
    raise exception 'T-LEG-01 : une ancienne version des CGU a été acceptée';
  exception when invalid_parameter_value then null;
  end;
  perform accept_terms(current_terms_version(), true);
  if (select terms_version from profiles where id = app_user_id()) <> current_terms_version() then
    raise exception 'T-LEG-01 : acceptation des CGU non enregistrée';
  end if;

  -- Sans consentement, aucun interdit ne s'enregistre.
  begin
    perform profile_onboard(array['maghrebi'], array['pork']::dietary_flag[]);
    raise exception 'T-LEG-03 : des interdits enregistrés sans consentement explicite';
  exception when insufficient_privilege then null;
  end;
end $$;

select give_diet_consent();
select profile_onboard(array['maghrebi', 'east-asian'], array['pork', 'shellfish']::dietary_flag[]);

do $$
begin
  if (select onboarded_at from profiles where id = app_user_id()) is null then
    raise exception 'T-ONB-02 : onboarded_at doit être rempli';
  end if;
  if (select array_agg(cuisine_slug order by cuisine_slug) from profile_cuisines) <> array['east-asian', 'maghrebi'] then
    raise exception 'T-ONB-02 : cuisines mal enregistrées';
  end if;
  if my_exclusions() <> array['pork', 'shellfish']::dietary_flag[] then
    raise exception 'T-ONB-02 : exclusions mal enregistrées : %', my_exclusions();
  end if;
end $$;

-- « Aucune contrainte » est une réponse : elle vide les exclusions.
select profile_set_preferences(array['maghrebi'], '{}'::dietary_flag[]);
do $$
begin
  if cardinality(my_exclusions()) <> 0 then raise exception 'T-ONB-04 : les exclusions auraient dû être vidées'; end if;
end $$;

-- Les préférences d'Amina sont invisibles et inaccessibles à Tom.
do $$
declare n int;
begin
  select count(*) into n from profile_exclusions where profile_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
  if n <> 0 then raise exception 'T-ONB-05 : Tom lit les exclusions d''Amina'; end if;
  begin
    insert into profile_exclusions (profile_id, flag) values ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'egg');
    raise exception 'T-ONB-05 : Tom a écrit dans les préférences d''Amina';
  exception when insufficient_privilege then null;
  end;
end $$;

-- Un nom d'utilisateur invalide est refusé.
do $$
begin
  begin
    update profiles set username = 'A B' where id = app_user_id();
    raise exception 'T-PRO-03 : nom d''utilisateur invalide accepté';
  exception when check_violation then null;
  end;
  -- Personne ne se nomme modérateur, ni ne s'invente un consentement.
  begin
    update profiles set is_moderator = true where id = app_user_id();
    raise exception 'T-MOD-01 : un utilisateur s''est nommé modérateur';
  exception when insufficient_privilege then null;
  end;
end $$;

\echo '-- retirer son consentement efface les interdits'
select give_diet_consent();
select profile_set_preferences(array['maghrebi'], array['gluten']::dietary_flag[]);
select withdraw_diet_consent();
do $$
begin
  if cardinality(my_exclusions()) <> 0 then raise exception 'T-LEG-04 : interdits conservés après retrait du consentement'; end if;
  if (select diet_consent_at from profiles where id = app_user_id()) is not null then
    raise exception 'T-LEG-04 : consentement encore enregistré après retrait';
  end if;
end $$;

rollback;
