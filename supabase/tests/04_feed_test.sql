-- L'accueil selon les choix de chacun (T-ACC).
begin;
set local role authenticated;

\echo '-- accueil de Priya (vegetarienne, sud-asiatique)'
set local request.jwt.claims = '{"sub":"f81498e9-a866-50d7-a546-e0792b54c0c3"}';
do $$
declare
  n int;
  first_cuisines text[];
begin
  select count(*) into n from home_feed(50, 0) where dietary_flags && array['meat', 'fish', 'shellfish']::dietary_flag[];
  if n <> 0 then raise exception 'T-ACC-02 : % plats interdits dans l''accueil de Priya', n; end if;

  select count(*) into n from home_feed(50, 0) where author_id = app_user_id();
  if n <> 0 then raise exception 'T-ACC-04 : Priya voit ses propres recettes dans l''accueil'; end if;

  select count(*) into n from home_feed(50, 0) where copied_from is not null and modified_by_id is distinct from author_id;
  if n <> 0 then raise exception 'T-ACC-05 : des copies telles quelles inondent l''accueil'; end if;

  select array_agg(cuisine) into first_cuisines from (select cuisine from home_feed(10, 0)) f;
  if not (first_cuisines <@ array['south-asian', 'southeast-asian']) then
    raise exception 'T-ACC-01 : les dix premiers plats devraient être de ses cuisines : %', first_cuisines;
  end if;

  select count(*) into n from home_feed(20, 0) where visibility = 'private';
  if n <> 0 then raise exception 'T-ACC-04 : recette privée dans l''accueil'; end if;
end $$;

\echo '-- pagination sans doublon'
do $$
begin
  if exists (select id from home_feed(20, 0) intersect select id from home_feed(20, 20)) then
    raise exception 'T-ACC-06 : la page 2 répète la page 1';
  end if;
end $$;

\echo '-- filtre video'
do $$
begin
  if exists (select 1 from home_feed(50, 0, 'video') where not has_video) then
    raise exception 'T-ACC-07 : le filtre vidéo laisse passer des photos';
  end if;
end $$;

rollback;
