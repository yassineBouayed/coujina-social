/**
 * Ce que les deux générateurs d'amorçage partagent : la lecture du livre, les
 * identifiants stables, l'échappement SQL.
 *
 * Les identifiants des recettes sont DÉRIVÉS du slug (un UUID v5 maison) : la
 * base, les données fictives et le mode démo du téléphone parlent ainsi de la
 * même recette sans se concerter.
 */
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';

import { ROOT, readPsv, load, norm } from '../refdata/refdata.mjs';
import { buildIndex, loadRecipes, matchItem } from '../probe/probe.mjs';

export { ROOT };

export const EDITORIAL_ID = 'c0c0c0c0-0000-4000-8000-000000000001';
export const SEED_DIR = path.join(ROOT, 'supabase', 'seed');

export function stableUuid(name) {
  const h = crypto.createHash('sha1').update(`coujina-social:${name}`).digest('hex');
  const variant = ((parseInt(h[16], 16) & 0x3) | 0x8).toString(16);
  return `${h.slice(0, 8)}-${h.slice(8, 12)}-5${h.slice(13, 16)}-${variant}${h.slice(17, 20)}-${h.slice(20, 32)}`;
}

export const q = (v) =>
  v === null || v === undefined ? 'null' : `'${String(v).replace(/'/g, "''")}'`;
export const num = (v) => (v === null || v === undefined || v === '' ? 'null' : String(Number(v)));
export const arr = (values, type) =>
  `array[${values.map(q).join(', ')}]::${type}[]`;

/** Un générateur pseudo-aléatoire à graine : les mêmes données à chaque passe. */
export function rng(seed) {
  let s = seed >>> 0;
  return () => {
    s = (s + 0x6d2b79f5) >>> 0;
    let t = s;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export const cuisines = () => readPsv('cuisines.psv').rows;
export const continents = () => readPsv('continents.psv').rows;
export const countries = () => readPsv('countries.psv').rows;

const MEAT_CATEGORIES = new Set(['viandes', 'volailles', 'charcuterie']);

/**
 * Les drapeaux d'un ingrédient résolu, plus `meat` quand il descend d'une
 * catégorie de viande. `meat` n'existe pas dans le référentiel d'origine.
 */
export function flagsOf(resolved) {
  const flags = new Set(resolved.dietary_flags ?? []);
  if (MEAT_CATEGORIES.has(resolved.category_slug)) flags.add('meat');
  if (flags.has('pork')) flags.add('meat');
  return [...flags].sort();
}

/** Les termes du référentiel et leurs drapeaux : la table ingredient_terms. */
export function ingredientTerms() {
  const data = load();
  const index = buildIndex(data);
  const terms = new Map();
  for (const t of index.terms) {
    const resolved = index.bySlug.get(t.slug);
    if (!resolved || !t.term_norm) continue;
    const flags = flagsOf(resolved);
    const prev = terms.get(t.term_norm) ?? [];
    terms.set(t.term_norm, [...new Set([...prev, ...flags])].sort());
  }
  return { index, terms };
}

/** Le titre français -> l'image Wikimedia candidate (data/plats-images.txt). */
function imageMap() {
  const file = path.join(ROOT, 'data', 'plats-images.txt');
  const map = new Map();
  if (!fs.existsSync(file)) return map;
  for (const line of fs.readFileSync(file, 'utf8').split(/\r?\n/)) {
    const [title, url] = line.split('\t');
    if (title && url && url.startsWith('https://')) map.set(title.trim(), url.trim());
  }
  return map;
}

/**
 * Le livre de couJina, prêt pour la base : 1 039 recettes, chacune avec ses
 * drapeaux (rattachement au référentiel, repris de l'ancien projet), son pays,
 * son image candidate et une date de publication étalée sur 90 jours.
 */
export function loadBook() {
  const { index } = ingredientTerms();
  const images = imageMap();
  const countryRows = countries();
  const byName = new Map(countryRows.map((c) => [c.name_fr.toLowerCase(), c.slug]));
  const random = rng(1039);

  return loadRecipes({ recursive: true }).map((r) => {
    const flags = new Set();
    for (const line of r.ingredients ?? []) {
      if (line.optional === true) continue;
      const hit = matchItem(line.item ?? '', index);
      // Le flou ne décide d'un interdit que s'il est sûr de lui.
      if (!hit.slug || (hit.match_type === 'fuzzy' && hit.score < 0.6)) continue;
      for (const f of flagsOf(index.bySlug.get(hit.slug))) flags.add(f);
    }
    const country = r.country ?? byName.get(String(r.origin ?? '').toLowerCase()) ?? null;
    const daysAgo = Math.floor(random() * 90);
    return {
      id: stableUuid(`recipe:${r.slug}`),
      slug: r.slug,
      title: r.title?.fr ?? r.slug,
      title_en: r.title?.en ?? null,
      native_name: r.native_name ?? null,
      description: (r.notes ?? []).map((n) => n.fr).join('\n'),
      cuisine: r.cuisine,
      country,
      meal_type: r.meal_type,
      difficulty: r.difficulty ?? 'medium',
      prep_min: r.times?.prep_min ?? null,
      cook_min: r.times?.cook_min ?? null,
      servings: r.servings ?? 4,
      cover_url: images.get(r.title?.fr ?? '') ?? null,
      flags: [...flags].sort(),
      days_ago: daysAgo,
      ingredients: (r.ingredients ?? []).map((l) => ({
        raw: l.raw ?? l.item ?? '',
        qty: l.qty ?? null,
        unit: l.unit ?? null,
        item: l.item ?? '',
        optional: l.optional === true,
        group: l.group ?? null,
      })),
      steps: (r.steps ?? []).map((s) => ({ body: s.fr ?? '', minutes: null })),
    };
  });
}

/** Miroir de detect_flags() en SQL : un terme du référentiel trouvé comme mot entier. */
export function detectFlags(lines, terms = ingredientTerms().terms) {
  const flags = new Set();
  for (const line of lines) {
    const plain = ` ${norm(line)} `;
    const singular = ` ${norm(line).replace(/([a-z]{3,})[sx]\b/g, '$1')} `;
    for (const [term, f] of terms) {
      if (plain.includes(` ${term} `) || singular.includes(` ${term} `)) f.forEach((x) => flags.add(x));
    }
  }
  return [...flags].sort();
}

export function write(file, sql) {
  fs.mkdirSync(SEED_DIR, { recursive: true });
  fs.writeFileSync(path.join(SEED_DIR, file), sql);
}
