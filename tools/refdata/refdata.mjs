/**
 * Lecture et résolution du référentiel d'ingrédients (jalon J1).
 *
 * Les fichiers `.psv` de `data/` sont la source de vérité : ils se relisent en
 * diff, se corrigent à la main et n'ont pas besoin d'une base pour être
 * validés. Tout le reste — le SQL d'amorçage, les statistiques, les réponses du
 * critère de sortie — en est dérivé.
 */
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

export const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
export const DATA_DIR = path.join(ROOT, 'data');

/* ------------------------------------------------------------- constantes */

export const DIETARY_FLAGS = [
  'pork', 'alcohol', 'gluten', 'peanut', 'tree_nut', 'dairy', 'egg', 'fish', 'shellfish',
];
export const AVAILABILITY = ['common', 'specialty', 'hard'];
export const STORAGE = ['pantry', 'fridge', 'freezer', 'counter'];
export const UNITS = ['piece', 'g', 'ml', 'bunch', 'tbsp', 'tsp', 'pinch'];
export const LANGS = ['fr', 'en'];

/** Rareté croissante. Un substitut ne doit jamais être plus dur à trouver. */
export const AVAILABILITY_RANK = { common: 0, specialty: 1, hard: 2 };

/* ---------------------------------------------------------- normalisation */

// Doit rester le miroir exact de refdata_norm() côté SQL : c'est cette égalité
// qui permet de détecter les collisions de termes ici, avant la base.
const ACCENTED = 'àáâãäåçèéêëìíîïñòóôõöùúûüýÿ';
const PLAIN = 'aaaaaaceeeeiiiinooooouuuuyy';

export function norm(value) {
  let text = String(value).toLowerCase().replaceAll('\u0153', 'oe').replaceAll('\u00e6', 'ae');
  text = Array.from(text)
    .map((ch) => {
      const i = ACCENTED.indexOf(ch);
      return i === -1 ? ch : PLAIN[i];
    })
    .join('');
  return text.replace(/[^a-z0-9]+/g, ' ').replace(/\s+/g, ' ').trim();
}

/* --------------------------------------------------------------- lecture */

/** Lit un `.psv` : `#` en début de ligne = commentaire, première ligne = entête. */
export function readPsv(file) {
  const raw = fs.readFileSync(path.join(DATA_DIR, file), 'utf8');
  const rows = [];
  let header = null;

  raw.split(/\r?\n/).forEach((line, index) => {
    if (!line.trim() || line.startsWith('#')) return;
    const cells = line.split('|');
    if (!header) {
      header = cells;
      return;
    }
    const row = { __line: index + 1, __file: file, __cells: cells.length };
    header.forEach((key, i) => {
      row[key] = (cells[i] ?? '').trim();
    });
    rows.push(row);
  });

  if (!header) throw new Error(`${file} : aucune ligne d'entête`);
  return { header, rows };
}

const bool = (v) => (v === '' ? null : v === 'y');
const int = (v) => (v === '' ? null : Number(v));
const flags = (v) => (v === '' ? null : v === '-' ? [] : v.split(',').map((f) => f.trim()));
const blank = (v) => (v === '' ? null : v);

/* ----------------------------------------------------------- chargement */

export function load() {
  const categories = readPsv('categories.psv').rows.map((r) => ({
    ...r,
    sort_order: Number(r.sort_order),
  }));

  const ingredients = readPsv('ingredients.psv').rows.map((r) => ({
    __line: r.__line,
    __cells: r.__cells,
    slug: r.slug,
    parent: blank(r.parent),
    name_fr: r.name_fr,
    name_en: r.name_en,
    category_slug: r.category,
    dietary_flags: flags(r.flags),
    shelf_life_days: int(r.shelf_life_days),
    is_perishable: bool(r.perish),
    storage: blank(r.storage),
    availability: blank(r.avail),
    is_staple: bool(r.staple),
    default_unit: blank(r.unit),
    substitute: blank(r.substitute),
    substitute_note: blank(r.substitute_note),
  }));

  const synonyms = readPsv('synonyms.psv').rows.map((r) => ({
    __line: r.__line,
    ingredient: r.ingredient,
    lang: r.lang,
    term: r.term,
  }));

  const bySlug = new Map(ingredients.map((i) => [i.slug, i]));
  const byCategory = new Map(categories.map((c) => [c.slug, c]));

  return { categories, ingredients, synonyms, bySlug, byCategory };
}

/* ----------------------------------------------------------- résolution */

/**
 * Applique l'héritage canonique -> variante, exactement comme la vue
 * `ingredients_resolved`. Une variante hérite de tout ce qu'elle ne redéfinit
 * pas ; les drapeaux, eux, s'unissent — le filtre alimentaire doit être
 * conservateur (SPEC 5).
 */
export function resolve(ingredient, bySlug) {
  const parent = ingredient.parent ? bySlug.get(ingredient.parent) : null;
  const pick = (key, fallback = null) =>
    ingredient[key] ?? (parent ? parent[key] : null) ?? fallback;

  const own = ingredient.dietary_flags ?? [];
  const inherited = parent?.dietary_flags ?? [];
  const unionFlags = [...new Set([...own, ...inherited])].sort();

  return {
    slug: ingredient.slug,
    parent_slug: ingredient.parent,
    is_canonical: !ingredient.parent,
    name_fr: ingredient.name_fr,
    name_en: ingredient.name_en,
    category_slug: ingredient.category_slug,
    dietary_flags: unionFlags,
    shelf_life_days: pick('shelf_life_days'),
    is_perishable: pick('is_perishable', true),
    storage: pick('storage'),
    availability: pick('availability', 'common'),
    is_staple: pick('is_staple', false),
    default_unit: pick('default_unit', 'piece'),
    substitute_slug: pick('substitute'),
    substitute_note: pick('substitute_note'),
    __line: ingredient.__line,
  };
}

export function resolveAll({ ingredients, bySlug }) {
  return ingredients.map((i) => resolve(i, bySlug));
}

/** Tous les termes qui doivent rattacher vers un ingrédient, primaires inclus. */
export function allTerms({ ingredients, synonyms }) {
  const terms = [];
  for (const ing of ingredients) {
    terms.push({ ingredient: ing.slug, lang: 'fr', term: ing.name_fr, is_primary: true });
    terms.push({ ingredient: ing.slug, lang: 'en', term: ing.name_en, is_primary: true });
  }
  for (const syn of synonyms) {
    terms.push({ ...syn, is_primary: false });
  }
  return terms;
}
