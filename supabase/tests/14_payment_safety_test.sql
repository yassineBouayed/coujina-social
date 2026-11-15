-- L'argent réel et la sécurité allergènes (T-PAY, T-ALL) — 3e passage du panel.
begin;

\echo '-- precommande Stripe : premium d''un an, idempotente, fermee a l''app'
do $$
declare
  before timestamptz;
  ok boolean;
begin
  select premium_until into before from profiles where id = '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b';  -- tom
  ok := record_preorder_payment('549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b', 'cs_test_tom', 2900, 'EUR');
  if not ok then raise exception 'T-PAY-01 : paiement non enregistré'; end if;
  if (select premium_until from profiles where id = '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b') < now() + interval '364 days' then
    raise exception 'T-PAY-01 : le paiement n''a pas ouvert un an de Premium';
  end if;
  if record_preorder_payment('549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b', 'cs_test_tom', 2900, 'EUR') then
    raise exception 'T-PAY-02 : le même paiement Stripe a compté deux fois';
  end if;
  if (select count(*) from preorders where stripe_session_id = 'cs_test_tom') <> 1 then
    raise exception 'T-PAY-02 : doublon de précommande';
  end if;
end $$;

\echo '-- essai de 30 jours'
select start_trial('69e35bef-6695-5b4f-89f7-684f67bd404c', 30);  -- amina
set local role authenticated;
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';
do $$
begin
  if not is_premium() then raise exception 'T-PAY-03 : l''essai n''ouvre pas le Premium'; end if;
  perform family_create('Famille Benali');  -- possible pendant l'essai
  begin
    perform record_preorder_payment(app_user_id(), 'cs_faux', 2900, 'eur');
    raise exception 'T-PAY-04 : un utilisateur s''est offert le Premium';
  exception when insufficient_privilege then null;
  end;
  begin
    perform start_trial(app_user_id(), 3650);
    raise exception 'T-PAY-04 : un utilisateur s''est offert un essai';
  exception when insufficient_privilege then null;
  end;
end $$;

\echo '-- allergene manquant : masquage immediat'
insert into reports (reporter_id, recipe_id, reason, details)
values (app_user_id(), '3f0de9c8-e489-54ae-9da1-b4c419f90451', 'allergen_missing', 'Pâte de curry à la crevette ?');  -- curry de Léa
set local request.jwt.claims = '{"sub":"f81498e9-a866-50d7-a546-e0792b54c0c3"}';  -- priya, abonnée de Léa
do $$
begin
  if exists (select 1 from recipes where id = '3f0de9c8-e489-54ae-9da1-b4c419f90451') then
    raise exception 'T-ALL-01 : la recette signalée « allergène manquant » reste visible';
  end if;
end $$;
set local request.jwt.claims = '{"sub":"3dd979f4-93c0-5058-8eb7-8e06046c8682"}';  -- léa, l'autrice
do $$
begin
  if (select moderation_reason from recipe_cards where id = '3f0de9c8-e489-54ae-9da1-b4c419f90451') not like 'Masquée par précaution%' then
    raise exception 'T-ALL-01 : l''autrice ne voit pas pourquoi sa recette est masquée';
  end if;
end $$;

\echo '-- verification : signalement classe, recette rendue'
reset role;
update profiles set is_moderator = true where id = 'ed018e6a-4007-5baf-bcf6-ab10a793deec';  -- lucas
set local role authenticated;
set local request.jwt.claims = '{"sub":"ed018e6a-4007-5baf-bcf6-ab10a793deec"}';
do $$
begin
  perform moderation_dismiss((select report_id from moderation_queue() where recipe_id = '3f0de9c8-e489-54ae-9da1-b4c419f90451'), 'Pâte végane, vérifiée');
end $$;
set local request.jwt.claims = '{"sub":"f81498e9-a866-50d7-a546-e0792b54c0c3"}';  -- priya
do $$
begin
  if not exists (select 1 from recipes where id = '3f0de9c8-e489-54ae-9da1-b4c419f90451') then
    raise exception 'T-ALL-02 : la recette vérifiée n''est pas rendue';
  end if;
end $$;

\echo '-- au-dela de 5 signalements par jour, plus de masquage automatique'
reset role;
do $$
declare i int;
begin
  for i in 1..6 loop
    insert into reports (reporter_id, recipe_id, reason) select '549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b', id, 'allergen_missing'
      from recipes where slug is not null order by slug offset i limit 1;
  end loop;
  insert into reports (reporter_id, recipe_id, reason) values ('549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b', '154cf5f9-8f7b-5751-b9c8-c50b695803d2', 'allergen_missing');
  if (select moderation_hidden_at from recipes where id = '154cf5f9-8f7b-5751-b9c8-c50b695803d2') is not null then
    raise exception 'T-ALL-03 : un signaleur en rafale masque encore des recettes';
  end if;
end $$;

\echo '-- le rapport de l''argent reel'
do $$
begin
  if not exists (select 1 from beta_money_metrics() where metric = 'Ont payé (précommande)' and value like '3 /%') then
    raise exception 'T-PAY-05 : le rapport ne compte pas les 3 précommandes fictives';
  end if;
  if not exists (select 1 from beta_money_metrics() where metric = 'Ont payé après un export') then
    raise exception 'T-PAY-05 : « payé après un export » absent du rapport';
  end if;
end $$;

rollback;
