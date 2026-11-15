-- Le réseau encore vide : défi de la semaine, qui suivre, activité (T-VIDE).
begin;
set local role authenticated;
set local request.jwt.claims = '{"sub":"f81498e9-a866-50d7-a546-e0792b54c0c3"}';  -- priya

\echo '-- le defi de la semaine'
do $$
declare
  ch challenges;
  rid uuid;
begin
  select * into ch from current_challenge();
  if ch.id is null then raise exception 'T-VIDE-01 : aucun défi en cours'; end if;
  if (select count(*) from current_challenge()) <> 1 then raise exception 'T-VIDE-01 : plusieurs défis en même temps'; end if;
  if not exists (select 1 from challenge_entries() where id = 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a') then
    raise exception 'T-VIDE-02 : le dal de Priya, inscrit au défi, n''apparaît pas';
  end if;
  if exists (select 1 from challenge_entries() where dietary_flags && array['meat', 'fish', 'shellfish']::dietary_flag[]) then
    raise exception 'T-VIDE-02 : le défi montre ce que Priya ne mange pas';
  end if;

  rid := recipe_save(null, jsonb_build_object('title', 'Chana masala', 'visibility', 'public',
    'ingredients', jsonb_build_array(jsonb_build_object('raw', '400 g de pois chiches')),
    'steps', jsonb_build_array(jsonb_build_object('body', 'Mijoter.'))));
  perform recipe_join_challenge(rid);
  if not exists (select 1 from challenge_entries() where id = rid) then
    raise exception 'T-VIDE-03 : la recette inscrite n''est pas dans le défi';
  end if;
  begin
    perform recipe_join_challenge('154cf5f9-8f7b-5751-b9c8-c50b695803d2');  -- le msemen d'Amina
    raise exception 'T-VIDE-03 : Priya a inscrit la recette d''Amina au défi';
  exception when no_data_found then null;
  end;
end $$;

\echo '-- qui suivre'
do $$
begin
  if not exists (select 1 from who_to_follow()) then raise exception 'T-VIDE-04 : aucune suggestion'; end if;
  if exists (select 1 from who_to_follow() w join follows f on f.followee_id = w.id and f.follower_id = app_user_id()) then
    raise exception 'T-VIDE-04 : on propose quelqu''un que Priya suit déjà';
  end if;
  if exists (select 1 from (select shared_cuisines, lag(shared_cuisines) over () as before from who_to_follow()) w
             where w.shared_cuisines > w.before) then
    raise exception 'T-VIDE-04 : les suggestions ne sont pas triées par cuisines partagées';
  end if;
  -- Priya suit déjà les deux personnes qui partagent ses cuisines : le tri se
  -- vérifie sur quelqu'un de neuf.
  set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom
  perform profile_onboard(array['south-asian'], '{}');
  if (select shared_cuisines from who_to_follow() limit 1) < 1 then
    raise exception 'T-VIDE-04 : Tom aime la cuisine sud-asiatique et on ne lui propose pas Priya ou Léa en premier';
  end if;
  set local request.jwt.claims = '{"sub":"f81498e9-a866-50d7-a546-e0792b54c0c3"}';  -- priya
end $$;

\echo '-- activite'
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';  -- amina
do $$
begin
  if not exists (select 1 from my_activity() where kind = 'copy_modified' and actor_username = 'lucas.bouffe') then
    raise exception 'T-VIDE-05 : Amina ne voit pas que Lucas a modifié son msemen';
  end if;
  if not exists (select 1 from my_activity() where kind = 'follow') then
    raise exception 'T-VIDE-05 : Amina ne voit pas ses nouveaux abonnés';
  end if;
  perform activity_mark_seen();
  if activity_unread() <> 0 then raise exception 'T-VIDE-06 : encore du « nouveau » après lecture'; end if;
end $$;

rollback;
