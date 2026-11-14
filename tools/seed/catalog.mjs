/**
 * npm run seed:catalog  ->  supabase/seed/catalog.generated.sql
 *
 * Les référentiels (cuisines, continents, pays avec leurs coordonnées), les
 * termes d'ingrédients et leurs drapeaux, le compte éditorial « couJina », et
 * les 1 039 recettes du livre, toutes publiques. Idempotent : rejoué, il ne
 * double rien.
 */
import {
  EDITORIAL_ID, arr, continents, countries, cuisines, ingredientTerms, loadBook, num, q, write,
} from './shared.mjs';

const out = [];
const push = (s) => out.push(s);

push('-- GÉNÉRÉ par `npm run seed:catalog` — ne pas modifier à la main.');
push('begin;');

for (const c of cuisines()) {
  push(`insert into cuisines (slug, name_fr, name_en, sort_order, gradient_from, gradient_to) values (${q(c.slug)}, ${q(c.name_fr)}, ${q(c.name_en)}, ${num(c.sort_order)}, ${q(c.gradient_from)}, ${q(c.gradient_to)})
  on conflict (slug) do update set name_fr = excluded.name_fr, name_en = excluded.name_en, sort_order = excluded.sort_order, gradient_from = excluded.gradient_from, gradient_to = excluded.gradient_to;`);
}
for (const c of continents()) {
  push(`insert into continents (slug, name_fr, name_en, sort_order) values (${q(c.slug)}, ${q(c.name_fr)}, ${q(c.name_en)}, ${num(c.sort_order)})
  on conflict (slug) do update set name_fr = excluded.name_fr, name_en = excluded.name_en, sort_order = excluded.sort_order;`);
}
for (const c of countries()) {
  push(`insert into countries (slug, name_fr, name_en, cuisine, continent, flag, lat, lng, sort_order) values (${q(c.slug)}, ${q(c.name_fr)}, ${q(c.name_en)}, ${q(c.cuisine)}, ${q(c.continent)}, ${q(c.flag)}, ${num(c.lat)}, ${num(c.lng)}, ${num(c.sort_order)})
  on conflict (slug) do update set name_fr = excluded.name_fr, name_en = excluded.name_en, cuisine = excluded.cuisine, continent = excluded.continent, flag = excluded.flag, lat = excluded.lat, lng = excluded.lng, sort_order = excluded.sort_order;`);
}

const { terms } = ingredientTerms();
const termRows = [...terms].map(([term, flags]) => `(${q(term)}, ${arr(flags, 'dietary_flag')})`);
for (let i = 0; i < termRows.length; i += 200) {
  push(`insert into ingredient_terms (term_norm, flags) values\n  ${termRows.slice(i, i + 200).join(',\n  ')}\n  on conflict (term_norm) do update set flags = excluded.flags;`);
}

push(`insert into profiles (id, username, display_name, bio, is_editorial, onboarded_at)
  values (${q(EDITORIAL_ID)}, 'coujina', 'Le livre couJina', 'Les recettes de référence de couJina, de 50 pays.', true, now())
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, is_editorial = true;`);

const book = loadBook();
for (const r of book) {
  push(`insert into recipes (id, author_id, slug, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, dietary_flags, created_at, updated_at)
  values (${q(r.id)}, ${q(EDITORIAL_ID)}, ${q(r.slug)}, ${q(r.title)}, ${q(r.native_name)}, ${q(r.description)}, ${q(r.cuisine)}, ${q(r.country)}, ${q(r.meal_type)}, ${q(r.difficulty)}, ${num(r.prep_min)}, ${num(r.cook_min)}, ${num(r.servings)}, 'fr', 'public', ${q(r.cover_url)}, ${arr(r.flags, 'dietary_flag')}, now() - interval '${r.days_ago} days', now() - interval '${r.days_ago} days')
  on conflict (id) do update set title = excluded.title, native_name = excluded.native_name, description = excluded.description, cuisine = excluded.cuisine, country = excluded.country, meal_type = excluded.meal_type, difficulty = excluded.difficulty, prep_min = excluded.prep_min, cook_min = excluded.cook_min, servings = excluded.servings, cover_url = excluded.cover_url, dietary_flags = excluded.dietary_flags;`);
  push(`delete from recipe_ingredients where recipe_id = ${q(r.id)};`);
  if (r.ingredients.length) push(`insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) values\n  ${r.ingredients
    .map((l, i) => `(${q(r.id)}, ${i}, ${q(l.raw)}, ${num(l.qty)}, ${q(l.unit)}, ${q(l.item)}, ${l.optional}, ${q(l.group)})`)
    .join(',\n  ')};`);
  push(`delete from recipe_steps where recipe_id = ${q(r.id)};`);
  if (r.steps.length) push(`insert into recipe_steps (recipe_id, position, body) values\n  ${r.steps
    .map((s, i) => `(${q(r.id)}, ${i}, ${q(s.body)})`)
    .join(',\n  ')};`);
}

push('commit;');
write('catalog.generated.sql', out.join('\n') + '\n');

const flagged = book.filter((r) => r.flags.length).length;
const withImage = book.filter((r) => r.cover_url).length;
const noCountry = book.filter((r) => !r.country).length;
console.log(`${book.length} recettes, ${flagged} avec au moins un drapeau, ${withImage} avec une image candidate, ${noCountry} sans pays`);
console.log(`${terms.size} termes d'ingrédients`);
console.log('-> supabase/seed/catalog.generated.sql');
