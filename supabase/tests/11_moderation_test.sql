-- La modération (T-MOD) : file des signalements, masquage motivé, feuille d'opérations.
begin;

-- Lucas devient modérateur (fait par l'équipe, en SQL : jamais depuis l'app).
update profiles set is_moderator = true where id = 'ed018e6a-4007-5baf-bcf6-ab10a793deec';

set local role authenticated;

\echo '-- Amina signale un allergene manquant sur les tacos de Diego'
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';
insert into reports (reporter_id, recipe_id, reason, details)
values (app_user_id(), '19b6fd5b-a771-522a-ace0-70a67067a544', 'allergen_missing', 'Il y a des arachides dans la sauce.');
do $$
begin
  begin
    perform moderation_queue();
    raise exception 'T-MOD-01 : Amina, simple utilisatrice, lit la file de modération';
  exception when insufficient_privilege then null;
  end;
end $$;

\echo '-- Lucas, moderateur, traite la file'
set local request.jwt.claims = '{"sub":"ed018e6a-4007-5baf-bcf6-ab10a793deec"}';
do $$
declare q record;
begin
  select * into q from moderation_queue() where recipe_id = '19b6fd5b-a771-522a-ace0-70a67067a544';
  if q.report_id is null or q.reason <> 'allergen_missing' then raise exception 'T-MOD-02 : signalement absent de la file'; end if;
  begin
    perform moderation_hide_recipe(q.recipe_id, '');
    raise exception 'T-MOD-03 : masquage sans motif accepté';
  exception when invalid_parameter_value then null;
  end;
  perform moderation_hide_recipe(q.recipe_id, 'Allergène non signalé (arachides)');
  if exists (select 1 from moderation_queue() where recipe_id = q.recipe_id) then
    raise exception 'T-MOD-03 : le signalement reste ouvert après masquage';
  end if;
  if not exists (select 1 from ops_weekly(2) where resolved >= 1 and within_24h >= 1) then
    raise exception 'T-MOD-05 : la feuille d''opérations ne compte pas le signalement traité';
  end if;
end $$;

\echo '-- la recette masquee disparait pour les autres, pas pour son auteur'
set local request.jwt.claims = '{"sub":"6f8af8f2-632e-57d6-b01e-705195e4132f"}';  -- kenji, abonné de Diego
do $$
begin
  if exists (select 1 from recipes where id = '19b6fd5b-a771-522a-ace0-70a67067a544') then
    raise exception 'T-MOD-04 : Kenji voit encore une recette masquée';
  end if;
  if exists (select 1 from home_feed(50, 0) where id = '19b6fd5b-a771-522a-ace0-70a67067a544') then
    raise exception 'T-MOD-04 : recette masquée dans l''accueil';
  end if;
  if exists (select 1 from trending_recipes('month', p_respect_diet => false, p_limit => 100) t
             where (t.recipe).id = '19b6fd5b-a771-522a-ace0-70a67067a544') then
    raise exception 'T-MOD-04 : recette masquée dans le classement';
  end if;
end $$;
set local request.jwt.claims = '{"sub":"d60940aa-e2b9-5be9-b000-dcbf4cf769e2"}';  -- diego, l'auteur
do $$
begin
  if (select moderation_reason from recipe_cards where id = '19b6fd5b-a771-522a-ace0-70a67067a544') is distinct from 'Allergène non signalé (arachides)' then
    raise exception 'T-MOD-04 : l''auteur ne voit pas le motif du masquage (DSA, exposé des motifs)';
  end if;
  begin
    update recipes set moderation_hidden_at = null where id = '19b6fd5b-a771-522a-ace0-70a67067a544';
    raise exception 'T-MOD-06 : l''auteur a levé lui-même le masquage';
  exception when insufficient_privilege then null;
  end;
end $$;

\echo '-- une recette masquee ne se copie pas'
reset role;
update recipes set moderation_hidden_at = now(), moderation_reason = 'test'
 where id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2';  -- le msemen d'Amina, public
set local role authenticated;
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom
do $$
begin
  begin
    perform copy_recipe('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 'private');
    raise exception 'T-MOD-07 : Tom a copié une recette masquée';
  exception when no_data_found then null;
  end;
end $$;

rollback;
