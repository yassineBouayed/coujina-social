-- Le Tour du monde, les profils, les abonnements (T-GLO, T-PRO, T-SOC).
begin;
set local role authenticated;
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';  -- amina

\echo '-- globe'
do $$
begin
  if (select count(*) from globe_countries()) <> 50 then raise exception 'T-GLO-01 : 50 pays attendus'; end if;
  if (select count(*) from globe_countries() where recipe_count > 0) < 45 then
    raise exception 'T-GLO-01 : trop de pays sans recette';
  end if;
  if exists (select 1 from country_recipes('maroc') where country <> 'maroc') then
    raise exception 'T-GLO-02 : country_recipes rend un autre pays';
  end if;
  if exists (select 1 from country_recipes('france', 50) where dietary_flags && array['pork', 'alcohol']::dietary_flag[]) then
    raise exception 'T-GLO-03 : le globe ignore ce qu''Amina ne mange pas';
  end if;
end $$;

\echo '-- profil et abonnements'
do $$
declare p record;
begin
  select * into p from profile_summary('6181e113-9005-5113-87e3-2c5e1ce00abb');  -- omar
  if not p.is_following then raise exception 'T-SOC-01 : Amina suit Omar'; end if;
  if not p.follows_me then raise exception 'T-SOC-01 : Omar suit Amina'; end if;
  if p.is_me then raise exception 'T-PRO-01 : is_me faux positif'; end if;

  delete from follows where follower_id = app_user_id() and followee_id = '6181e113-9005-5113-87e3-2c5e1ce00abb';
  if (select is_following from profile_summary('6181e113-9005-5113-87e3-2c5e1ce00abb')) then
    raise exception 'T-SOC-02 : le désabonnement n''a pas pris';
  end if;
  insert into follows (follower_id, followee_id) values (app_user_id(), '6181e113-9005-5113-87e3-2c5e1ce00abb');

  begin
    insert into follows (follower_id, followee_id) values ('6181e113-9005-5113-87e3-2c5e1ce00abb', 'ed018e6a-4007-5baf-bcf6-ab10a793deec');
    raise exception 'T-SOC-03 : Amina a abonné Omar à Lucas à sa place';
  exception when insufficient_privilege then null;
  end;

  begin
    insert into follows (follower_id, followee_id) values (app_user_id(), app_user_id());
    raise exception 'T-SOC-04 : on peut se suivre soi-même';
  exception when check_violation then null;
  end;

  -- Le profil de Marie, vu par Amina : seules les recettes publiques comptent.
  if exists (select 1 from user_recipes('ed48de41-79b0-595b-a0cd-984366f827e6') where visibility <> 'public') then
    raise exception 'T-PRO-02 : le profil de Marie montre des recettes non publiques à Amina';
  end if;
  if (select count(*) from search_profiles('omar')) = 0 then raise exception 'T-SOC-05 : recherche de profil vide'; end if;
end $$;

rollback;
