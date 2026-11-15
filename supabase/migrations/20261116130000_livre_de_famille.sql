-- =============================================================================
-- couJina social — le livre de famille, la fonctionnalité premium
--
-- Un cercle privé où une famille range ses recettes — celles de la
-- grand-mère, et les versions que chacun en a tirées, crédits compris — et
-- qu'on exporte en livre PDF (dans l'application).
--
--   * UN abonnement par famille : seul le créateur du livre paie ; les proches
--     le rejoignent gratuitement avec un code.
--   * On n'y range que SES recettes (écrites ou copiées) : on ne met pas dans
--     un cercle privé la recette d'un autre sans l'avoir faite sienne.
--   * Une recette « Moi seul » rangée dans le livre devient visible des
--     membres, et d'eux seuls.
--   * L'abonnement échu : le livre reste lisible, on n'y ajoute plus rien.
--
-- `premium_until` est posé à la main par l'équipe pendant la bêta (premium
-- offert aux testeurs) ; l'achat dans les magasins viendra le remplir ensuite.
-- =============================================================================

alter table profiles add column if not exists premium_until timestamptz;

create or replace function is_premium(p_profile uuid default null)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce((select premium_until > now() from profiles where id = coalesce(p_profile, app_user_id())), false);
$$;

create table if not exists family_books (
  id          uuid primary key default gen_random_uuid(),
  name        text not null check (char_length(btrim(name)) between 1 and 60),
  owner_id    uuid not null references profiles(id) on delete cascade,
  invite_code text not null unique default upper(substr(md5(gen_random_uuid()::text), 1, 8)),
  created_at  timestamptz not null default now()
);

create table if not exists family_members (
  book_id    uuid not null references family_books(id) on delete cascade,
  profile_id uuid not null references profiles(id) on delete cascade,
  role       text not null default 'member' check (role in ('owner', 'member')),
  joined_at  timestamptz not null default now(),
  primary key (book_id, profile_id)
);

create table if not exists family_recipes (
  book_id   uuid not null references family_books(id) on delete cascade,
  recipe_id uuid not null references recipes(id) on delete cascade,
  added_by  uuid not null references profiles(id) on delete cascade,
  note      text not null default '' check (char_length(note) <= 280),
  added_at  timestamptz not null default now(),
  primary key (book_id, recipe_id)
);

alter table family_books   enable row level security;
alter table family_members enable row level security;
alter table family_recipes enable row level security;

create or replace function is_family_member(p_book uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (select 1 from family_members where book_id = p_book and profile_id = app_user_id());
$$;

/** Une recette rangée dans un livre dont je suis membre. */
create or replace function in_my_family_book(p_recipe uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from family_recipes fr join family_members fm on fm.book_id = fr.book_id
     where fr.recipe_id = p_recipe and fm.profile_id = app_user_id());
$$;

-- Toutes les écritures passent par les fonctions ci-dessous : lecture seule en direct.
drop policy if exists family_books_read on family_books;
create policy family_books_read on family_books for select using (is_family_member(id));
drop policy if exists family_members_read on family_members;
create policy family_members_read on family_members for select using (is_family_member(book_id));
drop policy if exists family_recipes_read on family_recipes;
create policy family_recipes_read on family_recipes for select using (is_family_member(book_id));

-- Une recette d'un livre se lit par les membres, quelle que soit sa confidentialité.
drop policy if exists recipes_read on recipes;
create policy recipes_read on recipes for select
  using ((can_view_recipe(author_id, visibility) or in_my_family_book(id))
         and (moderation_hidden_at is null or author_id = app_user_id()));

create or replace function family_create(p_name text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := app_user_id();
  bid uuid;
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  if not is_premium(me) then raise exception 'premium_required' using errcode = '42501'; end if;
  insert into family_books (name, owner_id) values (btrim(p_name), me) returning id into bid;
  insert into family_members (book_id, profile_id, role) values (bid, me, 'owner');
  return bid;
end $$;

/** Rejoindre avec le code : gratuit, 30 personnes au plus par livre. */
create or replace function family_join(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := app_user_id();
  bid uuid;
begin
  if me is null then raise exception 'not_authenticated' using errcode = '28000'; end if;
  select id into bid from family_books where invite_code = upper(btrim(p_code));
  if bid is null then raise exception 'family_not_found' using errcode = 'P0002'; end if;
  if (select count(*) from family_members where book_id = bid) >= 30 then
    raise exception 'family_full' using errcode = '22023';
  end if;
  insert into family_members (book_id, profile_id) values (bid, me) on conflict do nothing;
  return bid;
end $$;

create or replace function family_leave(p_book uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if exists (select 1 from family_books where id = p_book and owner_id = app_user_id()) then
    -- Le créateur qui part supprime le livre ; les recettes, elles, restent à leurs auteurs.
    delete from family_books where id = p_book;
  else
    delete from family_members where book_id = p_book and profile_id = app_user_id();
    delete from family_recipes where book_id = p_book and added_by = app_user_id();
  end if;
end $$;

create or replace function family_add_recipe(p_book uuid, p_recipe uuid, p_note text default '')
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not is_family_member(p_book) then raise exception 'family_not_found' using errcode = 'P0002'; end if;
  if not is_premium((select owner_id from family_books where id = p_book)) then
    raise exception 'premium_required' using errcode = '42501';
  end if;
  if not exists (select 1 from recipes where id = p_recipe and author_id = app_user_id()) then
    -- Une recette d'un autre : on l'enregistre d'abord, puis on range sa copie.
    raise exception 'recipe_not_found' using errcode = 'P0002';
  end if;
  insert into family_recipes (book_id, recipe_id, added_by, note)
  values (p_book, p_recipe, app_user_id(), left(coalesce(p_note, ''), 280))
  on conflict (book_id, recipe_id) do update set note = excluded.note;
end $$;

create or replace function family_remove_recipe(p_book uuid, p_recipe uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from family_recipes
   where book_id = p_book and recipe_id = p_recipe
     and (added_by = app_user_id() or exists (select 1 from family_books where id = p_book and owner_id = app_user_id()));
end $$;

create or replace function my_families()
returns table (id uuid, name text, invite_code text, is_owner boolean, members int, recipes int, owner_premium boolean)
language sql
stable
security definer
set search_path = public
as $$
  select b.id, b.name, case when b.owner_id = app_user_id() then b.invite_code end,
         b.owner_id = app_user_id(),
         (select count(*)::int from family_members m where m.book_id = b.id),
         (select count(*)::int from family_recipes r where r.book_id = b.id),
         is_premium(b.owner_id)
    from family_books b
   where is_family_member(b.id)
   order by b.created_at;
$$;

/** Le livre : ses recettes (cartes complètes, crédits compris), qui les a rangées, et leur mot. */
create or replace function family_book_recipes(p_book uuid)
returns table (note text, added_by_name text, added_at timestamptz, recipe recipe_cards)
language sql
stable
security invoker
as $$
  select fr.note, p.display_name, fr.added_at, rc
    from family_recipes fr
    join recipe_cards rc on rc.id = fr.recipe_id
    join profiles p on p.id = fr.added_by
   where fr.book_id = p_book and is_family_member(p_book)
   order by rc.title;
$$;

grant execute on function is_premium(uuid), family_create(text), family_join(text), family_leave(uuid),
  family_add_recipe(uuid, uuid, text), family_remove_recipe(uuid, uuid), my_families(), family_book_recipes(uuid)
  to authenticated;
grant select on family_books, family_members, family_recipes to authenticated;
