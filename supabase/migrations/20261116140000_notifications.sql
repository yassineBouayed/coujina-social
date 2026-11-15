-- =============================================================================
-- couJina social — les notifications push, sobres
--
-- Le Customer Shark : « sans notification, rien ne me fait revenir le
-- deuxième jour ». Trois cas, pas un de plus :
--
--   « X a copié votre recette »   (et ses variantes « a fait sa version »)
--   « Y vous suit »
--   « Nouveau défi : … »          le lundi
--
-- Et trois règles, tenues ici plutôt que dans l'application :
--   * au plus UNE notification par personne et par 20 heures, qui regroupe
--     tout ce qui s'est passé (« Lucas et 2 autres ont copié vos recettes ») ;
--   * rien entre 21 h et 9 h (heure de Paris) ;
--   * chaque cas se coupe dans le profil.
--
-- La file se remplit par déclencheurs ; la fonction Edge `push-dispatch`
-- (supabase/functions) la vide toutes les 15 minutes vers le service Expo.
-- =============================================================================

alter table profiles add column if not exists notify_copies    boolean not null default true;
alter table profiles add column if not exists notify_follows   boolean not null default true;
alter table profiles add column if not exists notify_challenge boolean not null default true;
grant update (notify_copies, notify_follows, notify_challenge) on profiles to authenticated;

create table if not exists push_devices (
  expo_token text primary key,
  profile_id uuid not null references profiles(id) on delete cascade,
  platform   text not null default '' check (platform in ('', 'ios', 'android', 'web')),
  updated_at timestamptz not null default now()
);
alter table push_devices enable row level security;
drop policy if exists push_devices_self on push_devices;
create policy push_devices_self on push_devices for select using (profile_id = app_user_id());

/** Un jeton appartient au dernier compte connecté sur ce téléphone. */
create or replace function register_push_token(p_token text, p_platform text default '')
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if app_user_id() is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  if p_token !~ '^Expo(nent)?PushToken\[.+\]$' then raise exception 'invalid_token' using errcode = '22023'; end if;
  insert into push_devices (expo_token, profile_id, platform, updated_at)
  values (p_token, app_user_id(), coalesce(p_platform, ''), now())
  on conflict (expo_token) do update set profile_id = excluded.profile_id, platform = excluded.platform, updated_at = now();
end $$;

create or replace function unregister_push_token(p_token text)
returns void
language sql
security definer
set search_path = public
as $$
  delete from push_devices where expo_token = p_token and profile_id = app_user_id();
$$;

create table if not exists notification_outbox (
  id           bigint generated always as identity primary key,
  profile_id   uuid not null references profiles(id) on delete cascade,
  kind         text not null check (kind in ('copy', 'copy_modified', 'follow', 'challenge')),
  actor_name   text not null default '',
  recipe_id    uuid,
  recipe_title text not null default '',
  created_at   timestamptz not null default now(),
  sent_at      timestamptz
);
create index if not exists notification_outbox_pending_idx on notification_outbox (profile_id) where sent_at is null;
alter table notification_outbox enable row level security;
-- Aucune policy : la file n'est lue que par la fonction d'envoi.

-- -----------------------------------------------------------------------------
-- Ce qui remplit la file
-- -----------------------------------------------------------------------------
create or replace function enqueue_copy_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  author uuid;
  title text;
begin
  select r.author_id, r.title into author, title from recipes r where r.id = new.source_id;
  if author is null or author = new.copier_id then return new; end if;
  if not (select notify_copies from profiles where id = author) then return new; end if;
  if exists (select 1 from blocks where (blocker_id = author and blocked_id = new.copier_id)
                                     or (blocker_id = new.copier_id and blocked_id = author)) then
    return new;
  end if;
  insert into notification_outbox (profile_id, kind, actor_name, recipe_id, recipe_title)
  values (author, case when new.modified then 'copy_modified' else 'copy' end,
          coalesce((select nullif(display_name, '') from profiles where id = new.copier_id),
                   (select username from profiles where id = new.copier_id)),
          new.source_id, title);
  return new;
end $$;

drop trigger if exists recipe_copies_notify on recipe_copies;
create trigger recipe_copies_notify after insert on recipe_copies
  for each row execute function enqueue_copy_notification();

create or replace function enqueue_follow_notification()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if not (select notify_follows from profiles where id = new.followee_id) then return new; end if;
  insert into notification_outbox (profile_id, kind, actor_name)
  values (new.followee_id, 'follow',
          coalesce((select nullif(display_name, '') from profiles where id = new.follower_id),
                   (select username from profiles where id = new.follower_id)));
  return new;
end $$;

drop trigger if exists follows_notify on follows;
create trigger follows_notify after insert on follows
  for each row execute function enqueue_follow_notification();

/** Le lundi : le nouveau défi, une fois par personne et par semaine. */
create or replace function enqueue_weekly_challenge()
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  ch challenges;
  n int;
begin
  select * into ch from current_challenge();
  if ch.id is null then return 0; end if;
  insert into notification_outbox (profile_id, kind, recipe_title)
  select p.id, 'challenge', ch.title
    from profiles p
   where p.notify_challenge
     and exists (select 1 from push_devices d where d.profile_id = p.id)
     and not exists (select 1 from notification_outbox o where o.profile_id = p.id and o.kind = 'challenge'
                       and o.created_at >= current_week_start());
  get diagnostics n = row_count;
  return n;
end $$;

-- -----------------------------------------------------------------------------
-- Ce qui vide la file : un message par appareil, regroupé, au plus un par
-- 20 heures, jamais la nuit. `p_now` sert aux tests.
-- -----------------------------------------------------------------------------
create or replace function notification_drain(p_limit int default 200, p_now timestamptz default now())
returns table (outbox_ids bigint[], recipient_id uuid, expo_token text, title text, body text, data jsonb)
language plpgsql
security definer
set search_path = public
as $$
declare
  hour int := extract(hour from p_now at time zone 'Europe/Paris');
  r record;
  parts text[];
  n int;
  first_name text;
  ids bigint[];
begin
  if hour < 9 or hour >= 21 then return; end if;

  for r in
    select o.profile_id, array_agg(o.id order by o.id) as ids
      from notification_outbox o
     where o.sent_at is null
       and exists (select 1 from push_devices d where d.profile_id = o.profile_id)
       and not exists (select 1 from notification_outbox s where s.profile_id = o.profile_id
                         and s.sent_at > p_now - interval '20 hours')
     group by o.profile_id
     limit greatest(p_limit, 1)
  loop
    parts := '{}';
    ids := r.ids;

    -- Les copies, modifiées ou non, en une phrase.
    select count(*), min(actor_name) into n, first_name
      from notification_outbox where id = any (ids) and kind in ('copy', 'copy_modified');
    if n = 1 then
      parts := parts || (select case when kind = 'copy_modified' then actor_name || ' a fait sa version de « ' || recipe_title || ' »'
                                      else actor_name || ' a enregistré « ' || recipe_title || ' »' end
                           from notification_outbox where id = any (ids) and kind in ('copy', 'copy_modified') limit 1);
    elsif n > 1 then
      parts := parts || (first_name || ' et ' || (n - 1) || case when n = 2 then ' autre ont' else ' autres ont' end || ' enregistré vos recettes');
    end if;

    select count(*), min(actor_name) into n, first_name
      from notification_outbox where id = any (ids) and kind = 'follow';
    if n = 1 then parts := parts || (first_name || ' vous suit');
    elsif n > 1 then parts := parts || (first_name || ' et ' || (n - 1) || case when n = 2 then ' autre vous suivent' else ' autres vous suivent' end);
    end if;

    if exists (select 1 from notification_outbox where id = any (ids) and kind = 'challenge') then
      parts := parts || ('Nouveau défi : ' || (select recipe_title from notification_outbox where id = any (ids) and kind = 'challenge' limit 1));
    end if;

    update notification_outbox set sent_at = p_now where id = any (ids);

    return query
      select ids, r.profile_id, d.expo_token, 'couJina'::text, array_to_string(parts, ' · '),
             jsonb_build_object('screen', case when cardinality(parts) = 1 and parts[1] like 'Nouveau défi%' then 'challenge' else 'activity' end)
        from push_devices d where d.profile_id = r.profile_id;
  end loop;
end $$;

revoke all on function notification_drain(int, timestamptz) from public, anon, authenticated;
revoke all on function enqueue_weekly_challenge() from public, anon, authenticated;
grant execute on function register_push_token(text, text), unregister_push_token(text) to authenticated;
grant select on push_devices to authenticated;

-- Le lundi à 10 h (Paris, 9 h UTC en hiver) : le défi entre dans la file.
-- Seulement là où pg_cron existe (Supabase) ; la base de test locale n'en a pas.
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.schedule('coujina-weekly-challenge', '0 9 * * 1', 'select enqueue_weekly_challenge()');
  end if;
end $$;
