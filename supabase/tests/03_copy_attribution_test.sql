-- Copier une recette, telle quelle ou modifiée, et à qui revient le crédit (T-COP).
begin;
set local role authenticated;

\echo '-- copie telle quelle d''une recette du livre'
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom
do $$
declare
  cid uuid;
  again uuid;
  before int;
  r recipes;
begin
  select copies_count into before from recipes where slug = 'cassoulet';
  cid := copy_recipe((select id from recipes where slug = 'cassoulet'), 'public');
  select * into r from recipes where id = cid;
  if r.author_id <> app_user_id() then raise exception 'T-COP-01 : la copie n''est pas à Tom'; end if;
  if r.credit_author_id <> 'c0c0c0c0-0000-4000-8000-000000000001' then
    raise exception 'T-COP-01 : le crédit devrait revenir au livre couJina';
  end if;
  if r.modified_by_id is not null then raise exception 'T-COP-01 : une copie telle quelle n''est modifiée par personne'; end if;
  if (select count(*) from recipe_ingredients where recipe_id = cid)
     <> (select count(*) from recipe_ingredients where recipe_id = r.copied_from) then
    raise exception 'T-COP-01 : les ingrédients n''ont pas suivi';
  end if;
  if (select copies_count from recipes where slug = 'cassoulet') <> before + 1 then
    raise exception 'T-COP-03 : le compteur de copies n''a pas bougé';
  end if;

  again := copy_recipe((select id from recipes where slug = 'cassoulet'), 'public');
  if again <> cid then raise exception 'T-COP-04 : la deuxième copie aurait dû rendre la première'; end if;
  if (select copies_count from recipes where slug = 'cassoulet') <> before + 1 then
    raise exception 'T-COP-04 : la deuxième copie a compté deux fois';
  end if;
end $$;

\echo '-- la chaine : Omar copie le msemen modifie par Lucas (recette d''Amina)'
set local request.jwt.claims = '{"sub":"6181e113-9005-5113-87e3-2c5e1ce00abb"}';  -- omar
do $$
declare
  cid uuid := copy_recipe('32d1076d-a903-57bd-9a0e-319e544ccaf1', 'public');
  r recipes;
begin
  select * into r from recipes where id = cid;
  if r.credit_author_id <> '69e35bef-6695-5b4f-89f7-684f67bd404c' then
    raise exception 'T-COP-05 : le crédit d''origine (Amina) s''est perdu';
  end if;
  if r.modified_by_id <> 'ed018e6a-4007-5baf-bcf6-ab10a793deec' then
    raise exception 'T-COP-05 : « modifiée par Lucas » s''est perdu';
  end if;
end $$;

\echo '-- copie avec modifications'
do $$
declare
  rid uuid;
  r recipes;
begin
  rid := recipe_save(null, jsonb_build_object(
    'title', 'Bissara d''Omar au cumin fumé',
    'visibility', 'public',
    'ingredients', jsonb_build_array(jsonb_build_object('raw', '500 g de fèves sèches'), jsonb_build_object('raw', '2 c. à s. de cumin')),
    'steps', jsonb_build_array(jsonb_build_object('body', 'Cuire les fèves.'), jsonb_build_object('body', 'Mixer avec le cumin.'))
  ), (select id from recipes where slug = 'bissara'));
  select * into r from recipes where id = rid;
  if r.credit_author_id <> 'c0c0c0c0-0000-4000-8000-000000000001' then raise exception 'T-COP-02 : crédit d''origine perdu'; end if;
  if r.modified_by_id <> app_user_id() then raise exception 'T-COP-02 : « modifiée par Omar » attendu'; end if;
  if r.cuisine <> 'maghrebi' or r.country <> 'maroc' then raise exception 'T-COP-02 : cuisine et pays devraient suivre la source'; end if;
  if not exists (select 1 from recipe_copies where copy_id = rid and modified) then
    raise exception 'T-COP-02 : la copie modifiée doit compter dans les classements';
  end if;
end $$;

\echo '-- modifier plus tard une copie telle quelle la rend « modifiee par »'
do $$
declare
  cid uuid := copy_recipe((select id from recipes where slug = 'akara'), 'private');
  r recipes;
begin
  perform recipe_save(cid, jsonb_build_object(
    'title', 'Akara bien croustillants', 'visibility', 'private',
    'ingredients', jsonb_build_array(jsonb_build_object('raw', '250 g de haricots cornille')),
    'steps', jsonb_build_array(jsonb_build_object('body', 'Frire.'))));
  select * into r from recipes where id = cid;
  if r.modified_by_id <> app_user_id() then raise exception 'T-COP-06 : la copie modifiée doit porter « modifiée par »'; end if;
end $$;

\echo '-- une copie n''est jamais plus ouverte que sa source'
set local request.jwt.claims = '{"sub":"67c5aecd-680b-5574-aa4c-082784fe7707"}';  -- nadia, abonnée de Marie
-- Une éventuelle copie telle quelle de l'amorçage serait rendue telle quelle : on part de zéro.
delete from recipes where author_id = app_user_id() and copied_from = 'd311b89b-5143-56e3-9090-f3d65f707025' and modified_by_id is null;
do $$
declare
  cid uuid := copy_recipe('d311b89b-5143-56e3-9090-f3d65f707025', 'public');
  r recipes;
begin
  select * into r from recipes where id = cid;
  if r.visibility <> 'followers' then
    raise exception 'T-COP-07 : la copie d''une recette « abonnés » ne doit pas devenir publique (%)', r.visibility;
  end if;
  if recipe_set_visibility(r.id, 'public') <> 'followers' then
    raise exception 'T-COP-07 : recipe_set_visibility doit aussi borner';
  end if;
end $$;

\echo '-- refus'
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';  -- amina
do $$
begin
  begin
    perform copy_recipe('154cf5f9-8f7b-5751-b9c8-c50b695803d2');
    raise exception 'T-COP-08 : Amina a copié sa propre recette';
  exception when invalid_parameter_value then null;
  end;
  begin
    perform copy_recipe('7fe979fb-9be5-5747-b26e-88fb796989cd');
    raise exception 'T-COP-09 : Amina a copié la recette privée de Marie';
  exception when no_data_found then null;
  end;
  begin
    perform recipe_save(null, '{"title":"", "ingredients":[], "steps":[]}'::jsonb);
    raise exception 'T-REC-04 : une recette sans titre a été acceptée';
  exception when invalid_parameter_value then null;
  end;
end $$;

rollback;
