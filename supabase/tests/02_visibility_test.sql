-- Confidentialité des recettes (plan de test T-CONF).
--   Marie : « Gratin secret » privé, « Tarte Tatin » réservée aux abonnés.
--   Nadia suit Marie ; Amina, non. Sofia a bloqué Diego.
begin;
set local role authenticated;

\echo '-- confidentialite : Amina (ne suit pas Marie)'
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';
do $$
begin
  if exists (select 1 from recipes where id = '7fe979fb-9be5-5747-b26e-88fb796989cd') then
    raise exception 'T-CONF-01 : Amina voit la recette privée de Marie';
  end if;
  if exists (select 1 from recipes where id = 'd311b89b-5143-56e3-9090-f3d65f707025') then
    raise exception 'T-CONF-02 : Amina voit une recette réservée aux abonnés de Marie';
  end if;
  if exists (select 1 from recipe_ingredients where recipe_id = '7fe979fb-9be5-5747-b26e-88fb796989cd') then
    raise exception 'T-CONF-01 : les ingrédients d''une recette privée fuient';
  end if;
  -- Ses propres recettes, elle les voit toutes, privées comprises.
  if (select count(*) from recipes where author_id = app_user_id() and visibility = 'private') = 0 then
    raise exception 'T-CONF-05 : Amina devrait voir ses copies privées';
  end if;
end $$;

\echo '-- confidentialite : Nadia (abonnee de Marie)'
set local request.jwt.claims = '{"sub":"67c5aecd-680b-5574-aa4c-082784fe7707"}';
do $$
begin
  if not exists (select 1 from recipes where id = 'd311b89b-5143-56e3-9090-f3d65f707025') then
    raise exception 'T-CONF-03 : Nadia devrait voir la Tatin réservée aux abonnés';
  end if;
  if exists (select 1 from recipes where id = '7fe979fb-9be5-5747-b26e-88fb796989cd') then
    raise exception 'T-CONF-01 : une abonnée voit une recette privée';
  end if;
end $$;

\echo '-- confidentialite : Marie modifie une recette qui n''est pas a elle'
set local request.jwt.claims = '{"sub":"ed48de41-79b0-595b-a0cd-984366f827e6"}';
do $$
declare n int;
begin
  update recipes set title = 'pirate' where id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2';
  get diagnostics n = row_count;
  if n <> 0 then raise exception 'T-CONF-06 : Marie a modifié la recette d''Amina'; end if;
  delete from recipes where id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2';
  get diagnostics n = row_count;
  if n <> 0 then raise exception 'T-CONF-06 : Marie a supprimé la recette d''Amina'; end if;
end $$;

-- Marie rend sa Tatin publique : Amina la voit.
select recipe_set_visibility('d311b89b-5143-56e3-9090-f3d65f707025', 'public');
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';
do $$
begin
  if not exists (select 1 from recipes where id = 'd311b89b-5143-56e3-9090-f3d65f707025') then
    raise exception 'T-CONF-04 : la Tatin rendue publique reste invisible';
  end if;
end $$;

\echo '-- blocage : Sofia a bloque Diego'
set local request.jwt.claims = '{"sub":"c6512930-0382-50bb-b18a-db918ff78f26"}';
do $$
begin
  if exists (select 1 from recipes where id = '19b6fd5b-a771-522a-ace0-70a67067a544') then
    raise exception 'T-SOC-06 : Sofia voit les recettes de Diego qu''elle a bloqué';
  end if;
end $$;
set local request.jwt.claims = '{"sub":"d60940aa-e2b9-5be9-b000-dcbf4cf769e2"}';
do $$
begin
  if exists (select 1 from recipes where id = 'f4134598-19a8-5684-8ad4-3f26f1c91929') then
    raise exception 'T-SOC-06 : Diego voit les recettes de Sofia qui l''a bloqué';
  end if;
end $$;

\echo '-- anonyme'
set local role anon;
set local request.jwt.claims = '';
do $$
begin
  if exists (select 1 from recipes where visibility <> 'public') then
    raise exception 'T-CONF-07 : un visiteur non connecté voit une recette non publique';
  end if;
end $$;

rollback;
