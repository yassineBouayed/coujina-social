-- Les drapeaux alimentaires d'une recette écrite à la main, et la suppression de compte (T-REG, T-CPT).
begin;

\echo '-- detect_flags'
do $$
begin
  if not ('pork' = any (detect_flags(array['200 g de lardons fumés']))) then
    raise exception 'T-REG-01 : « lardons » devrait porter le porc : %', detect_flags(array['200 g de lardons fumés']);
  end if;
  if not ('meat' = any (detect_flags(array['1 poulet fermier']))) then
    raise exception 'T-REG-01 : « poulet » devrait porter la viande';
  end if;
  if cardinality(detect_flags(array['3 carottes', '1 oignon'])) <> 0 then
    raise exception 'T-REG-01 : carottes et oignon ne portent rien';
  end if;
end $$;

set local role authenticated;
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom

\echo '-- recipe_save calcule les drapeaux, et garde ceux que l''auteur declare'
do $$
declare
  rid uuid;
  r recipes;
begin
  rid := recipe_save(null, jsonb_build_object(
    'title', 'Quiche de Tom', 'visibility', 'public',
    'declared_flags', jsonb_build_array('gluten'),
    'ingredients', jsonb_build_array(
      jsonb_build_object('raw', '200 g de lardons'),
      jsonb_build_object('raw', '20 cl de crème'),
      jsonb_build_object('raw', '50 g de noix', 'optional', true)),
    'steps', jsonb_build_array(jsonb_build_object('body', 'Cuire 35 minutes.'))));
  select * into r from recipes where id = rid;
  if not (r.dietary_flags @> array['pork', 'gluten']::dietary_flag[]) then
    raise exception 'T-REG-02 : drapeaux attendus porc + gluten, obtenu %', r.dietary_flags;
  end if;
  if 'tree_nut' = any (r.dietary_flags) then
    raise exception 'T-REG-03 : une ligne facultative ne doit pas cacher le plat';
  end if;
end $$;

\echo '-- suppression de compte (Lea)'
set local request.jwt.claims = '{"sub":"3dd979f4-93c0-5058-8eb7-8e06046c8682"}';
select delete_my_account();
reset role;
do $$
begin
  if exists (select 1 from profiles where id = '3dd979f4-93c0-5058-8eb7-8e06046c8682') then
    raise exception 'T-CPT-02 : le profil de Léa existe encore';
  end if;
  if exists (select 1 from recipes where author_id = '3dd979f4-93c0-5058-8eb7-8e06046c8682') then
    raise exception 'T-CPT-02 : les recettes de Léa existent encore';
  end if;
  if exists (select 1 from follows where '3dd979f4-93c0-5058-8eb7-8e06046c8682' in (follower_id, followee_id)) then
    raise exception 'T-CPT-02 : les abonnements de Léa existent encore';
  end if;
  -- Les copies que d'autres ont faites restent à eux.
  if exists (select 1 from recipes where credit_author_id = '3dd979f4-93c0-5058-8eb7-8e06046c8682') then
    raise exception 'T-CPT-03 : un crédit pointe encore vers un compte supprimé';
  end if;
end $$;

rollback;
