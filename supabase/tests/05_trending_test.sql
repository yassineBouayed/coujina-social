-- Les plus copiées du jour, de la semaine, du mois (T-TOP).
begin;
set local role authenticated;
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';  -- amina

\echo '-- les trois periodes'
do $$
declare d int; w int; m int;
begin
  select count(*) into d from trending_recipes('day');
  select count(*) into w from trending_recipes('week');
  select count(*) into m from trending_recipes('month');
  if d = 0 or w = 0 or m = 0 then raise exception 'T-TOP-01 : un classement est vide (jour %, semaine %, mois %)', d, w, m; end if;
  if (select sum(period_copies) from trending_recipes('day', p_limit => 100))
     > (select sum(period_copies) from trending_recipes('week', p_limit => 100)) then
    raise exception 'T-TOP-01 : le jour compte plus de copies que la semaine';
  end if;
  if exists (select 1 from trending_recipes('week') t1 join trending_recipes('week') t2
             on t1.rank < t2.rank and t1.period_copies < t2.period_copies) then
    raise exception 'T-TOP-02 : le classement n''est pas trié par nombre de copies';
  end if;
end $$;

\echo '-- les filtres'
do $$
begin
  if exists (select 1 from trending_recipes('month', p_cuisine => 'maghrebi') t where (t.recipe).cuisine <> 'maghrebi') then
    raise exception 'T-TOP-03 : le filtre cuisine ne filtre pas';
  end if;
  if exists (select 1 from trending_recipes('month') t where (t.recipe).dietary_flags && array['pork', 'alcohol']::dietary_flag[]) then
    raise exception 'T-TOP-04 : du porc ou de l''alcool dans le classement d''Amina';
  end if;
  if not exists (select 1 from trending_recipes('month', p_respect_diet => false) t
                 where (t.recipe).dietary_flags && array['pork', 'alcohol']::dietary_flag[]) then
    raise exception 'T-TOP-05 : « tout voir » devrait montrer aussi ce qu''Amina ne mange pas';
  end if;
  if exists (select 1 from trending_recipes('month', p_respect_diet => false) t where (t.recipe).visibility <> 'public'
             and not can_view_recipe((t.recipe).author_id, (t.recipe).visibility)) then
    raise exception 'T-TOP-06 : une recette invisible apparaît dans le classement';
  end if;
end $$;

\echo '-- une personne compte une fois'
-- Le journal ne s'écrit pas à la main : sinon on gonflerait le classement.
do $$
begin
  begin
    insert into recipe_copies (source_id, copier_id)
      values ((select id from recipes where slug = 'cassoulet'), app_user_id());
    raise exception 'T-TOP-07 : recipe_copies est inscriptible en direct';
  exception when insufficient_privilege then null;
  end;
end $$;

create temp table t_before as
  select coalesce((select period_copies from trending_recipes('day', p_respect_diet => false, p_limit => 100) t
                   where (t.recipe).slug = 'cassoulet'), 0) as n;

-- Deux événements de la même personne (Lucas), posés en administrateur.
reset role;
insert into recipe_copies (source_id, copier_id)
  select id, 'ed018e6a-4007-5baf-bcf6-ab10a793deec'::uuid from recipes where slug = 'cassoulet'
  union all
  select id, 'ed018e6a-4007-5baf-bcf6-ab10a793deec'::uuid from recipes where slug = 'cassoulet';
set local role authenticated;

do $$
begin
  if (select period_copies from trending_recipes('day', p_respect_diet => false, p_limit => 100) t
       where (t.recipe).slug = 'cassoulet') <> (select n from t_before) + 1 then
    raise exception 'T-TOP-07 : une même personne a compté deux fois';
  end if;
end $$;

\echo '-- periode invalide'
do $$
begin
  begin
    perform trending_recipes('year');
    raise exception 'T-TOP-08 : période invalide acceptée';
  exception when invalid_parameter_value then null;
  end;
end $$;

rollback;
