-- =============================================================================
-- couJina social — le crédit des photos
--
-- Les photos du livre viennent de Wikimedia Commons, sous des licences (CC BY,
-- CC BY-SA, Licence Art Libre…) qui exigent de nommer l'auteur et la licence
-- là où la photo s'affiche. Ces trois colonnes portent ce crédit ; une photo
-- de couverture qui n'a pas été prise par l'auteur de la recette DOIT les
-- avoir remplies. Une photo envoyée par un utilisateur les laisse vides : elle
-- est à lui (conditions d'utilisation).
--
-- Le tri des 1 008 photos candidates est fait hors base, par
-- `npm run images:credits` (data/images/credits.json).
-- =============================================================================

alter table recipes add column if not exists cover_credit     text;
alter table recipes add column if not exists cover_license    text;
alter table recipes add column if not exists cover_source_url text;

comment on column recipes.cover_credit is
  'Crédit affiché sous la photo de couverture quand elle ne vient pas de l''auteur (ex. « Photo : X — CC BY 3.0, via Wikimedia Commons »).';

-- La carte d'une recette porte le crédit : une copie l'affiche aussi.
create or replace view recipe_cards with (security_invoker = true) as
select
  r.id, r.slug, r.title, r.native_name, r.description, r.cuisine, r.country, r.meal_type,
  c.name_fr as country_name_fr, c.name_en as country_name_en, c.flag as country_flag,
  r.difficulty, r.prep_min, r.cook_min, r.total_min, r.servings, r.lang,
  r.visibility, r.cover_url, r.video_url, (r.video_url is not null) as has_video,
  r.dietary_flags, r.copies_count, r.created_at, r.updated_at, r.copied_from,
  r.author_id, a.username as author_username, a.display_name as author_name,
  a.avatar_url as author_avatar, a.is_editorial as author_is_editorial,
  r.credit_author_id, ca.username as credit_username, ca.display_name as credit_name,
  r.modified_by_id, mb.username as modified_username, mb.display_name as modified_name,
  r.cover_credit, r.cover_license, r.cover_source_url
from recipes r
join profiles a on a.id = r.author_id
left join countries c on c.slug = r.country
left join profiles ca on ca.id = r.credit_author_id
left join profiles mb on mb.id = r.modified_by_id;

-- Une copie emporte le crédit de la photo qu'elle emporte.
create or replace function copy_cover_credit()
returns trigger
language plpgsql
as $$
begin
  if new.copied_from is not null and new.cover_credit is null then
    select cover_credit, cover_license, cover_source_url
      into new.cover_credit, new.cover_license, new.cover_source_url
      from recipes
     where id = new.copied_from and cover_url is not distinct from new.cover_url;
  end if;
  -- Une photo remplacée par l'auteur n'emporte plus l'ancien crédit.
  if tg_op = 'UPDATE' and new.cover_url is distinct from old.cover_url and new.cover_credit is not distinct from old.cover_credit then
    new.cover_credit := null;
    new.cover_license := null;
    new.cover_source_url := null;
  end if;
  return new;
end $$;

drop trigger if exists recipes_cover_credit on recipes;
create trigger recipes_cover_credit
  before insert or update of cover_url, copied_from on recipes
  for each row execute function copy_cover_credit();

grant select on recipe_cards to anon, authenticated;
