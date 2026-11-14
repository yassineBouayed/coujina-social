/**
 * npm run seed:fictive
 *   -> supabase/seed/fictive.generated.sql   les personnes fictives dans la base
 *   -> mobile/src/mock/mock.generated.ts     les mêmes, pour le mode démo du téléphone
 *
 * Source : data/fictive/personnes.json et data/fictive/recettes.json. Les
 * copies du livre sont tirées au sort AVEC UNE GRAINE (les mêmes à chaque
 * passe), pondérées par les cuisines de chacun, sans jamais toucher à ce
 * qu'il ne mange pas.
 *
 * Les dates sont relatives à now() : relancer l'amorçage rafraîchit les
 * classements du jour, de la semaine et du mois.
 */
import fs from 'node:fs';
import path from 'node:path';

import { EDITORIAL_ID, ROOT, arr, detectFlags, countries, cuisines, loadBook, num, q, rng, stableUuid, write } from './shared.mjs';

const read = (f) => JSON.parse(fs.readFileSync(path.join(ROOT, 'data', 'fictive', f), 'utf8'));
const { personnes, abonnements, blocages } = read('personnes.json');
const { recettes } = read('recettes.json');

const userId = (key) => (key === 'coujina' ? EDITORIAL_ID : stableUuid(`user:${key}`));
const byKey = new Map(personnes.map((p) => [p.key, p]));
const book = loadBook();
const bookBySlug = new Map(book.map((r) => [r.slug, r]));
const random = rng(2026);
const pick = (list) => list[Math.floor(random() * list.length)];

/** Les recettes « du moment » : copiées par presque tout le monde, récemment. */
const HOT = ['bissara', 'akara', 'aloo-bhorta', 'chakalaka', 'bissap', 'atkilt-wat', 'jollof-rice'];
const RANK = { private: 0, followers: 1, public: 2 };
const clamp = (wanted, source) => (RANK[wanted] > RANK[source] ? source : wanted);
const clash = (flags, exclusions) => flags.some((f) => exclusions.includes(f));

/* ------------------------------------------------------------ les copies */

const copies = []; // { id, source, sourceKind, copier, hoursAgo, visibility, modified }
const taken = new Set();

function addCopy(copier, source, hoursAgo, visibility, sourceVisibility) {
  const key = `${copier}:${source}`;
  if (taken.has(key)) return;
  taken.add(key);
  copies.push({
    id: stableUuid(`copy:${key}`),
    eventId: stableUuid(`copy-event:${key}`),
    copier,
    source,
    hoursAgo,
    visibility: clamp(visibility, sourceVisibility),
  });
}

const randomVisibility = () => {
  const x = random();
  return x < 0.7 ? 'private' : x < 0.9 ? 'public' : 'followers';
};
const randomHours = () => {
  const x = random();
  if (x < 0.3) return 1 + Math.floor(random() * 22); // dans les 24 h
  if (x < 0.6) return 26 + Math.floor(random() * 140); // dans la semaine
  return 170 + Math.floor(random() * 540); // dans le mois
};

for (const p of personnes) {
  if (!p.copies) continue;
  const allowed = book.filter((r) => !clash(r.flags, p.exclusions));

  // Les recettes du moment d'abord, puis le reste, pondéré par les cuisines.
  for (const slug of HOT) {
    const r = bookBySlug.get(slug);
    if (r && !clash(r.flags, p.exclusions) && random() < 0.85) {
      addCopy(p.key, r.id, 1 + Math.floor(random() * (slug === 'bissara' || slug === 'akara' ? 20 : 120)), randomVisibility(), 'public');
    }
  }
  const weighted = allowed.flatMap((r) => (p.cuisines.includes(r.cuisine) ? [r, r, r, r] : [r]));
  let guard = 0;
  while (copies.filter((c) => c.copier === p.key).length < p.copies && guard++ < 500) {
    const r = pick(weighted);
    addCopy(p.key, r.id, randomHours(), randomVisibility(), 'public');
  }
}

/* --------------------------------------- les recettes écrites, et leurs copies */

const own = recettes.map((r) => ({ ...r, id: stableUuid(`own:${r.key}`), author: userId(r.auteur) }));
const ownByKey = new Map(own.map((r) => [r.key, r]));

function sourceOf(ref) {
  if (ownByKey.has(ref)) {
    const s = ownByKey.get(ref);
    return { id: s.id, author: s.author, credit: s.copie_de ? sourceOf(s.copie_de).credit : s.author, visibility: s.visibility };
  }
  const b = bookBySlug.get(ref);
  if (!b) throw new Error(`copie_de inconnu : ${ref}`);
  return { id: b.id, author: EDITORIAL_ID, credit: EDITORIAL_ID, visibility: 'public' };
}

// Les abonnés copient, telles quelles, une recette publique sur deux de ceux qu'ils suivent.
for (const [follower, followee] of abonnements) {
  for (const r of own) {
    if (r.auteur !== followee || r.visibility === 'private' || r.copie_de) continue;
    const p = byKey.get(follower);
    if (!p || random() < 0.5) continue;
    const hours = Math.max(1, Math.floor(r.jours * 24 * random()));
    addCopy(follower, r.id, hours, 'private', r.visibility);
  }
}

/* -------------------------------------------------------------------- SQL */

const sql = [];
const push = (s) => sql.push(s);
push('-- GÉNÉRÉ par `npm run seed:fictive` depuis data/fictive/*.json — ne pas modifier à la main.');
push('-- Données FICTIVES : à charger sur une base de test, jamais en production.');
push('begin;');

for (const p of personnes) {
  const id = userId(p.key);
  push(`insert into profiles (id, username, display_name, bio, onboarded_at) values (${q(id)}, ${q(p.username)}, ${q(p.display_name)}, ${q(p.bio)}, ${p.onboarded ? "now() - interval '60 days'" : 'null'})
  on conflict (id) do update set username = excluded.username, display_name = excluded.display_name, bio = excluded.bio, onboarded_at = excluded.onboarded_at;`);
  push(`delete from profile_cuisines where profile_id = ${q(id)};`);
  if (p.cuisines.length) push(`insert into profile_cuisines (profile_id, cuisine_slug) select ${q(id)}, unnest(${arr(p.cuisines, 'text')});`);
  push(`delete from profile_exclusions where profile_id = ${q(id)};`);
  if (p.exclusions.length) push(`insert into profile_exclusions (profile_id, flag) select ${q(id)}, unnest(${arr(p.exclusions, 'dietary_flag')});`);
}

for (const [a, b] of abonnements) {
  push(`insert into follows (follower_id, followee_id, created_at) values (${q(userId(a))}, ${q(userId(b))}, now() - interval '40 days') on conflict do nothing;`);
}
for (const [a, b] of blocages) {
  push(`insert into blocks (blocker_id, blocked_id) values (${q(userId(a))}, ${q(userId(b))}) on conflict do nothing;`);
}

// Les recettes écrites, dans l'ordre du fichier : une copie modifiée vient
// toujours après sa source.
for (const r of own) {
  const src = r.copie_de ? sourceOf(r.copie_de) : null;
  const visibility = src ? clamp(r.visibility, src.visibility) : r.visibility;
  const when = `now() - interval '${r.jours * 24 + 2} hours'`;
  const declared = r.declared_flags ?? [];
  push(`insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, visibility, video_url, declared_flags, dietary_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  values (${q(r.id)}, ${q(r.author)}, ${q(r.title)}, ${q(r.native_name ?? null)}, ${q(r.description ?? '')}, ${q(r.cuisine)}, ${q(r.country)}, ${q(r.meal_type)}, ${q(r.difficulty)}, ${num(r.prep_min)}, ${num(r.cook_min)}, ${num(r.servings)}, ${q(visibility)}, ${q(r.video ?? null)}, ${arr(declared, 'dietary_flag')},
    (select coalesce(array_agg(distinct f order by f), '{}') from unnest(detect_flags(${arr(r.ingredients, 'text')}) || ${arr(declared, 'dietary_flag')}) f),
    ${q(src?.id ?? null)}, ${q(src?.credit ?? null)}, ${src ? q(r.author) : 'null'}, ${when}, ${when})
  on conflict (id) do update set title = excluded.title, visibility = excluded.visibility, dietary_flags = excluded.dietary_flags, created_at = excluded.created_at;`);
  push(`delete from recipe_ingredients where recipe_id = ${q(r.id)};`);
  push(`insert into recipe_ingredients (recipe_id, position, raw, item) values\n  ${r.ingredients.map((l, i) => `(${q(r.id)}, ${i}, ${q(l)}, ${q(l)})`).join(',\n  ')};`);
  push(`delete from recipe_steps where recipe_id = ${q(r.id)};`);
  push(`insert into recipe_steps (recipe_id, position, body) values\n  ${r.steps.map((s, i) => `(${q(r.id)}, ${i}, ${q(s)})`).join(',\n  ')};`);
  if (r.video) {
    push(`insert into recipe_media (id, recipe_id, owner_id, kind, storage_path, public_url, position) values (${q(stableUuid(`media:${r.key}`))}, ${q(r.id)}, ${q(r.author)}, 'video', ${q(`${r.author}/${r.key}.mp4`)}, ${q(r.video)}, 0) on conflict (id) do nothing;`);
  }
  if (src) {
    push(`insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values (${q(stableUuid(`copy-event:own:${r.key}`))}, ${q(src.id)}, ${q(r.id)}, ${q(r.author)}, true, ${when})
  on conflict (id) do update set created_at = excluded.created_at;`);
  }
}

// Les copies telles quelles : la recette est dupliquée, comme copy_recipe() le fait.
for (const c of copies) {
  const when = `now() - interval '${c.hoursAgo} hours'`;
  const copier = q(userId(c.copier));
  push(`insert into recipes (id, author_id, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, visibility, cover_url, video_url, dietary_flags, declared_flags, copied_from, credit_author_id, modified_by_id, created_at, updated_at)
  select ${q(c.id)}, ${copier}, title, native_name, description, cuisine, country, meal_type, difficulty, prep_min, cook_min, servings, lang, ${q(c.visibility)}, cover_url, video_url, dietary_flags, declared_flags, id, coalesce(credit_author_id, author_id), modified_by_id, ${when}, ${when}
    from recipes where id = ${q(c.source)}
  on conflict (id) do update set created_at = excluded.created_at;`);
  push(`insert into recipe_ingredients (recipe_id, position, raw, qty, unit, item, optional, group_name) select ${q(c.id)}, position, raw, qty, unit, item, optional, group_name from recipe_ingredients where recipe_id = ${q(c.source)} on conflict do nothing;`);
  push(`insert into recipe_steps (recipe_id, position, body, minutes) select ${q(c.id)}, position, body, minutes from recipe_steps where recipe_id = ${q(c.source)} on conflict do nothing;`);
  push(`insert into recipe_copies (id, source_id, copy_id, copier_id, modified, created_at) values (${q(c.eventId)}, ${q(c.source)}, ${q(c.id)}, ${copier}, false, ${when})
  on conflict (id) do update set created_at = excluded.created_at;`);
}

push('update recipes r set copies_count = (select count(*) from recipe_copies c where c.source_id = r.id);');
push('commit;');
write('fictive.generated.sql', sql.join('\n') + '\n');

/* --------------------------------------------- le mode démo du téléphone */

// Le livre entier ne part pas dans le téléphone : les recettes copiées, celles
// du moment, et quatre par pays pour que le globe ait de quoi montrer.
const wanted = new Set([...copies.map((c) => c.source), ...HOT.map((s) => bookBySlug.get(s)?.id)]);
const perCountry = new Map();
for (const r of book) {
  const n = perCountry.get(r.country) ?? 0;
  if (n < 4) { wanted.add(r.id); perCountry.set(r.country, n + 1); }
}

const card = (r, extra) => ({
  id: r.id, title: r.title, native_name: r.native_name ?? null, description: r.description ?? '',
  cuisine: r.cuisine, country: r.country ?? null, meal_type: r.meal_type ?? null,
  difficulty: r.difficulty, prep_min: r.prep_min ?? null, cook_min: r.cook_min ?? null, servings: r.servings,
  cover_url: r.cover_url ?? null, video_url: r.video ?? null, ...extra,
});

const mock = {
  editorialId: EDITORIAL_ID,
  cuisines: cuisines().map((c) => ({ slug: c.slug, name_fr: c.name_fr, name_en: c.name_en, from: c.gradient_from, to: c.gradient_to })),
  countries: countries().map((c) => ({ slug: c.slug, name_fr: c.name_fr, name_en: c.name_en, flag: c.flag, cuisine: c.cuisine, lat: Number(c.lat), lng: Number(c.lng) })),
  users: [
    { id: EDITORIAL_ID, username: 'coujina', display_name: 'Le livre couJina', bio: 'Les recettes de référence de couJina, de 50 pays.', is_editorial: true, cuisines: [], exclusions: [], onboarded: true },
    ...personnes.map((p) => ({ id: userId(p.key), username: p.username, display_name: p.display_name, bio: p.bio, is_editorial: false, cuisines: p.cuisines, exclusions: p.exclusions, onboarded: p.onboarded })),
  ],
  follows: abonnements.map(([a, b]) => [userId(a), userId(b)]),
  recipes: [
    ...book.filter((r) => wanted.has(r.id)).map((r) =>
      card(r, {
        author_id: EDITORIAL_ID, visibility: 'public', flags: r.flags, hours_ago: r.days_ago * 24,
        copied_from: null, credit_author_id: null, modified_by_id: null,
        ingredients: r.ingredients.map((l) => ({ raw: l.raw, optional: l.optional })),
        steps: r.steps.map((s) => s.body),
      })),
    ...own.map((r) => {
      const src = r.copie_de ? sourceOf(r.copie_de) : null;
      return card({ ...r }, {
        author_id: r.author, visibility: src ? clamp(r.visibility, src.visibility) : r.visibility,
        flags: [...new Set([...detectFlags(r.ingredients), ...(r.declared_flags ?? [])])].sort(), hours_ago: r.jours * 24 + 2,
        copied_from: src?.id ?? null, credit_author_id: src?.credit ?? null, modified_by_id: src ? r.author : null,
        ingredients: r.ingredients.map((l) => ({ raw: l, optional: false })),
        steps: r.steps,
      });
    }),
  ],
  copies: [
    ...copies.map((c) => ({ id: c.id, source: c.source, copier: userId(c.copier), hours_ago: c.hoursAgo, visibility: c.visibility, modified: false })),
    ...own.filter((r) => r.copie_de).map((r) => ({ id: r.id, source: sourceOf(r.copie_de).id, copier: r.author, hours_ago: r.jours * 24 + 2, visibility: r.visibility, modified: true })),
  ],
};

const mobileFile = path.join(ROOT, 'mobile', 'src', 'mock', 'mock.generated.ts');
fs.mkdirSync(path.dirname(mobileFile), { recursive: true });
fs.writeFileSync(
  mobileFile,
  `// GÉNÉRÉ par \`npm run seed:fictive\` — ne pas modifier à la main.\n// Données FICTIVES du mode démo (sans Supabase).\nimport type { MockData } from './types';\n\nexport const MOCK: MockData = ${JSON.stringify(mock)};\n`,
);

const day = copies.filter((c) => c.hoursAgo <= 24).length;
const week = copies.filter((c) => c.hoursAgo <= 168).length;
console.log(`${personnes.length} personnes, ${abonnements.length} abonnements, ${own.length} recettes écrites`);
console.log(`${copies.length} copies telles quelles : ${day} dans les 24 h, ${week} dans la semaine`);
console.log(`mode démo : ${mock.recipes.length} recettes`);
console.log('-> supabase/seed/fictive.generated.sql');
console.log('-> mobile/src/mock/mock.generated.ts');
