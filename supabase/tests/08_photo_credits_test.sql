-- Le crédit des photos (T-IMG) : exigé par les licences Creative Commons.
begin;

\echo '-- aucune photo du livre sans credit'
do $$
declare n int;
begin
  select count(*) into n from recipes where slug is not null and cover_url is not null and coalesce(cover_credit, '') = '';
  if n <> 0 then raise exception 'T-IMG-01 : % photos du livre sans crédit', n; end if;
  if (select count(*) from recipes where slug is not null and cover_url is not null) < 600 then
    raise exception 'T-IMG-01 : trop peu de photos créditées — data/images/credits.json manque-t-il ?';
  end if;
  if exists (select 1 from recipes where slug = 'berbere-maison' and cover_url is not null) then
    raise exception 'T-IMG-02 : la carte des langues berbères illustre encore le berbéré';
  end if;
end $$;

set local role authenticated;
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom

\echo '-- le credit suit la copie, et tombe avec la photo'
do $$
declare
  src recipes;
  cid uuid;
  r recipes;
begin
  select * into src from recipes where slug is not null and cover_credit is not null order by slug limit 1;
  delete from recipes where author_id = app_user_id() and copied_from = src.id;
  cid := copy_recipe(src.id, 'private');
  select * into r from recipes where id = cid;
  if r.cover_credit is distinct from src.cover_credit then
    raise exception 'T-IMG-03 : la copie a perdu le crédit de la photo';
  end if;
  if (select cover_credit from recipe_cards where id = cid) is null then
    raise exception 'T-IMG-03 : la carte de la copie ne porte pas le crédit';
  end if;

  update recipes set cover_url = 'https://example.test/ma-photo.jpg' where id = cid;
  if (select cover_credit from recipes where id = cid) is not null then
    raise exception 'T-IMG-04 : une photo remplacée par l''auteur garde le crédit de l''ancienne';
  end if;
end $$;

rollback;
