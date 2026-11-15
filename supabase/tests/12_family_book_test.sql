-- Le livre de famille, fonctionnalité premium (T-FAM).
--   « Famille Laurent » : Marie (premium, créatrice) et Nadia. Le gratin de
--   Marie est « Moi seul » et rangé dans le livre.
begin;
set local role authenticated;

\echo '-- Nadia, membre, lit le gratin prive de Marie ; Amina, non'
set local request.jwt.claims = '{"sub":"67c5aecd-680b-5574-aa4c-082784fe7707"}';  -- nadia
do $$
begin
  if not exists (select 1 from recipes where id = '7fe979fb-9be5-5747-b26e-88fb796989cd') then
    raise exception 'T-FAM-01 : Nadia ne lit pas le gratin rangé dans le livre de famille';
  end if;
  if (select count(*) from family_book_recipes((select id from family_books limit 1))) < 3 then
    raise exception 'T-FAM-01 : le livre n''affiche pas ses trois recettes';
  end if;
  if exists (select 1 from my_families() where invite_code is not null) then
    raise exception 'T-FAM-02 : le code d''invitation est montré à un simple membre';
  end if;
end $$;

set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';  -- amina
do $$
begin
  if exists (select 1 from recipes where id = '7fe979fb-9be5-5747-b26e-88fb796989cd') then
    raise exception 'T-FAM-01 : Amina, hors du livre, lit le gratin privé';
  end if;
  if exists (select 1 from family_book_recipes((select '00000000-0000-0000-0000-000000000000'::uuid))) then
    raise exception 'T-FAM-01 : lecture d''un livre inconnu';
  end if;
end $$;

\echo '-- creer un livre demande l''abonnement (ou l''essai)'
-- Tom n'est pas testeur : ni essai, ni abonnement.
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';
do $$
begin
  begin
    perform family_create('Famille Petit');
    raise exception 'T-FAM-03 : Tom, sans abonnement ni essai, a créé un livre';
  exception when insufficient_privilege then null;
  end;
end $$;
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';  -- amina

\echo '-- rejoindre avec le code, ranger une de ses recettes, pas celle d''un autre'
do $$
declare bid uuid;
begin
  bid := family_join('laurent1');
  if not is_family_member(bid) then raise exception 'T-FAM-04 : Amina n''a pas rejoint le livre'; end if;
  if not exists (select 1 from recipes where id = '7fe979fb-9be5-5747-b26e-88fb796989cd') then
    raise exception 'T-FAM-04 : une fois membre, Amina devrait lire le gratin';
  end if;
  perform family_add_recipe(bid, '154cf5f9-8f7b-5751-b9c8-c50b695803d2', 'Le msemen de ma mère');
  begin
    perform family_add_recipe(bid, 'c612fda8-9ff6-59c3-ab67-4b303c0b4d8a');  -- le dal de Priya
    raise exception 'T-FAM-05 : Amina a rangé la recette de Priya';
  exception when no_data_found then null;
  end;
  perform family_leave(bid);
  if exists (select 1 from recipes where id = '7fe979fb-9be5-5747-b26e-88fb796989cd') then
    raise exception 'T-FAM-06 : après avoir quitté le livre, Amina lit encore le gratin';
  end if;
end $$;

\echo '-- abonnement echu : lisible, plus d''ajout'
reset role;
update profiles set premium_until = now() - interval '1 day', trial_until = now() - interval '1 day' where id = 'ed48de41-79b0-595b-a0cd-984366f827e6';
set local role authenticated;
set local request.jwt.claims = '{"sub":"ed48de41-79b0-595b-a0cd-984366f827e6"}';  -- marie
do $$
declare bid uuid := (select id from my_families() limit 1);
begin
  if (select count(*) from family_book_recipes(bid)) = 0 then raise exception 'T-FAM-07 : livre illisible après échéance'; end if;
  begin
    perform family_add_recipe(bid, 'd311b89b-5143-56e3-9090-f3d65f707025');
    raise exception 'T-FAM-07 : ajout accepté avec un abonnement échu';
  exception when insufficient_privilege then null;
  end;
end $$;

rollback;
