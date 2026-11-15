-- Les notifications push (T-NOT) : la file, le regroupement, une par jour, jamais la nuit.
begin;
set local role authenticated;

\echo '-- Amina enregistre son telephone'
set local request.jwt.claims = '{"sub":"69e35bef-6695-5b4f-89f7-684f67bd404c"}';  -- amina
select register_push_token('ExponentPushToken[amina-test]', 'ios');
do $$
begin
  begin
    perform register_push_token('pas-un-jeton', 'ios');
    raise exception 'T-NOT-01 : un faux jeton a été accepté';
  exception when invalid_parameter_value then null;
  end;
end $$;

\echo '-- deux copies et un abonnement : un seul message, regroupe'
reset role;
delete from notification_outbox;  -- partir d'une file vide (l'amorçage en a rempli)
set local role authenticated;
set local request.jwt.claims = '{"sub":"549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b"}';  -- tom
select copy_recipe('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 'private');  -- le msemen d'Amina
insert into follows (follower_id, followee_id) values ('549f0e16-aa94-5b0d-aa2d-f8e6ae36d73b', '69e35bef-6695-5b4f-89f7-684f67bd404c');
set local request.jwt.claims = '{"sub":"67c5aecd-680b-5574-aa4c-082784fe7707"}';  -- nadia
select copy_recipe('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 'private');

reset role;
do $$
declare
  noon timestamptz := (current_date + time '12:00') at time zone 'Europe/Paris';
  night timestamptz := (current_date + time '23:00') at time zone 'Europe/Paris';
  m record;
  n int;
begin
  -- Jamais la nuit.
  select count(*) into n from notification_drain(200, night);
  if n <> 0 then raise exception 'T-NOT-03 : notification envoyée à 23 h'; end if;

  select count(*) into n from notification_drain(200, noon) where recipient_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
  -- (le drain a marqué la file : on relit ce qu'il a envoyé)
  if n <> 1 then raise exception 'T-NOT-02 : % messages pour Amina, un seul attendu', n; end if;
end $$;

do $$
declare
  noon timestamptz := (current_date + time '12:00') at time zone 'Europe/Paris';
  n int;
begin
  -- Tout ce qui attendait pour Amina est parti en un message.
  if exists (select 1 from notification_outbox where profile_id = '69e35bef-6695-5b4f-89f7-684f67bd404c' and sent_at is null) then
    raise exception 'T-NOT-02 : des évènements d''Amina restent en file après l''envoi groupé';
  end if;
  -- Une nouvelle copie l'après-midi attend le lendemain.
  insert into notification_outbox (profile_id, kind, actor_name, recipe_title)
  values ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'copy', 'Omar Haddad', 'Harira du ramadan');
  select count(*) into n from notification_drain(200, noon + interval '4 hours') where recipient_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
  if n <> 0 then raise exception 'T-NOT-04 : deuxième notification le même jour'; end if;
  select count(*) into n from notification_drain(200, noon + interval '1 day') where recipient_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
  if n <> 1 then raise exception 'T-NOT-04 : la notification du lendemain n''est pas partie'; end if;
end $$;

\echo '-- le texte regroupe, et les reglages'
do $$
declare
  body text;
begin
  delete from notification_outbox;
  insert into notification_outbox (profile_id, kind, actor_name, recipe_title) values
    ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'copy', 'Tom Petit', 'Msemen de ma mère'),
    ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'copy_modified', 'Nadia Kowalski', 'Msemen de ma mère'),
    ('69e35bef-6695-5b4f-89f7-684f67bd404c', 'follow', 'Tom Petit', '');
  select d.body into body from notification_drain(200, (current_date + 3 + time '12:00') at time zone 'Europe/Paris') d
   where d.recipient_id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
  if body not like '%et 1 autre ont enregistré vos recettes%' or body not like '%Tom Petit vous suit%' then
    raise exception 'T-NOT-02 : texte regroupé inattendu : %', body;
  end if;

  update profiles set notify_copies = false where id = '69e35bef-6695-5b4f-89f7-684f67bd404c';
  delete from notification_outbox;
end $$;

set local role authenticated;
set local request.jwt.claims = '{"sub":"6181e113-9005-5113-87e3-2c5e1ce00abb"}';  -- omar
select copy_recipe('154cf5f9-8f7b-5751-b9c8-c50b695803d2', 'private');
reset role;
do $$
begin
  if exists (select 1 from notification_outbox where profile_id = '69e35bef-6695-5b4f-89f7-684f67bd404c') then
    raise exception 'T-NOT-05 : copie notifiée alors qu''Amina a coupé ce cas';
  end if;
end $$;

\echo '-- personne ne vide la file depuis l''app'
set local role authenticated;
do $$
begin
  begin
    perform notification_drain();
    raise exception 'T-NOT-06 : un utilisateur peut vider la file';
  exception when insufficient_privilege then null;
  end;
end $$;

rollback;
