/**
 * Lecture des recettes générées et rattachement de leurs lignes d'ingrédients
 * au référentiel (jalon J2).
 *
 * Le jalon est un jalon de décision : il mesure, il ne construit pas. Tout ce
 * qui est ici sert à produire un nombre honnête — et notamment à ne jamais
 * compter comme « rattachée » une ligne accrochée au mauvais ingrédient, qui
 * est pire qu'une ligne non rattachée : elle remplit le panier de travers sans
 * rien signaler.
 */
import fs from 'node:fs';
import path from 'node:path';
import { ROOT, load, resolveAll, norm, allTerms } from '../refdata/refdata.mjs';
import { termCandidates, similarity, normalizeUnit } from './normalize.mjs';

export const RECIPES_DIR = path.join(ROOT, 'data', 'recipes');

/** Seuil du repli flou, identique à celui de match_ingredient() en base. */
export const FUZZY_THRESHOLD = 0.42;

export const MEAL_TYPES = ['main', 'starter', 'soup', 'salad', 'side', 'bread', 'dessert', 'drink'];
export const DIFFICULTIES = ['easy', 'medium', 'hard'];
export const RECIPE_UNITS = ['g', 'kg', 'ml', 'cl', 'l', 'piece', 'tbsp', 'tsp', 'pinch', 'bunch'];

/* --------------------------------------------------------------- lecture */

/**
 * Les recettes d'un répertoire.
 *
 * `dir` par défaut est `data/recipes` SANS descendre dans les sous-dossiers, et
 * ce n'est pas un détail d'implémentation : le corpus de la sonde J2 est le
 * répertoire plat, et il ne bouge plus. Les cuisines ajoutées au jalon J5
 * vivent dans `data/recipes/<cuisine>/`, où la mesure de J2 ne les voit pas —
 * sans quoi ajouter une recette au catalogue changerait rétroactivement le
 * chiffre sur lequel le projet a décidé de continuer.
 *
 * `tools/catalog/` charge, lui, l'arborescence entière.
 */
export function loadRecipes({ dir = RECIPES_DIR, recursive = false } = {}) {
  if (!fs.existsSync(dir)) return [];

  const files = [];
  const walk = (current, prefix) => {
    for (const entry of fs.readdirSync(current, { withFileTypes: true }).sort((a, b) => a.name.localeCompare(b.name))) {
      if (entry.isDirectory()) {
        if (recursive) walk(path.join(current, entry.name), path.posix.join(prefix, entry.name));
      } else if (entry.name.endsWith('.json')) {
        files.push({ dir: current, name: entry.name, rel: path.posix.join(prefix, entry.name) });
      }
    }
  };
  walk(dir, '');

  return files.map(({ dir: from, name, rel }) => {
    const raw = fs.readFileSync(path.join(from, name), 'utf8');
    let recipe;
    try {
      recipe = JSON.parse(raw);
    } catch (error) {
      throw new Error(`${rel} : JSON invalide — ${error.message}`);
    }
    // `__file` reste le nom de fichier seul : c'est lui que le validateur
    // compare au slug. `__path` porte le chemin, pour les messages d'erreur.
    recipe.__file = name;
    recipe.__path = rel;
    recipe.__dir = from;
    return recipe;
  });
}

/** Une ligne = une entrée de `ingredients`, aplatie et repérée par sa recette. */
export function loadLines(recipes = loadRecipes()) {
  const lines = [];
  for (const recipe of recipes) {
    (recipe.ingredients ?? []).forEach((ingredient, index) => {
      const { qty, unit } = normalizeUnit(ingredient.qty ?? null, ingredient.unit ?? null);
      lines.push({
        recipe: recipe.slug,
        index,
        raw: ingredient.raw ?? '',
        item: ingredient.item ?? '',
        prep: ingredient.prep ?? null,
        group: ingredient.group ?? null,
        optional: ingredient.optional === true,
        substitutes: ingredient.substitutes ?? [],
        qty,
        unit,
      });
    });
  }
  return lines;
}

/* ------------------------------------------------------------ index des termes */

/**
 * L'index de rattachement : tous les termes du référentiel, normalisés.
 * Les noms officiels y sont au même titre que les synonymes — c'est
 * exactement ce que contient `ingredient_synonyms` une fois amorcée.
 */
export function buildIndex(data = load()) {
  const resolved = resolveAll(data);
  const bySlug = new Map(resolved.map((r) => [r.slug, r]));
  const byTerm = new Map();
  const terms = [];

  for (const t of allTerms(data)) {
    const key = `${t.lang}:${norm(t.term)}`;
    const entry = { lang: t.lang, term: t.term, term_norm: norm(t.term), slug: t.ingredient, is_primary: t.is_primary };
    terms.push(entry);
    if (!byTerm.has(key)) byTerm.set(key, entry);
  }

  return { resolved, bySlug, byTerm, terms };
}

/* ------------------------------------------------------------ rattachement */

/**
 * Rattache un libellé. Renvoie toujours un objet : `slug` à null signifie
 * « aucun rattachement », et c'est une réponse, pas une erreur.
 *
 * La cascade suit celle de `match_recipe_item()` en base :
 *   exact -> singulier -> nettoyé -> générique -> flou (trigrammes).
 * On s'arrête à la première forme qui touche, donc au type le plus précis.
 */
export function matchItem(item, index, { lang = 'fr', threshold = FUZZY_THRESHOLD } = {}) {
  const candidates = termCandidates(item);

  for (const candidate of candidates) {
    const hit = index.byTerm.get(`${lang}:${candidate.term}`);
    if (hit) {
      return {
        slug: hit.slug,
        matched_term: hit.term,
        match_type: candidate.kind,
        score: 1,
        tried: candidate.term,
      };
    }
  }

  // Repli flou sur la forme nettoyée : c'est celle qui a le plus de chances de
  // ressembler à une entrée du référentiel sans en être une.
  const needle = candidates.find((c) => c.kind === 'stripped')?.term ?? candidates[0]?.term ?? '';
  let best = null;
  for (const entry of index.terms) {
    if (entry.lang !== lang) continue;
    const score = similarity(entry.term_norm, needle);
    if (score < threshold) continue;
    // Départage identique à celui de match_recipe_item() : score décroissant,
    // puis nom français croissant. Sans cette égalité, deux termes également
    // proches feraient diverger l'outil et la base sur la même donnée.
    const name = index.bySlug.get(entry.slug)?.name_fr ?? '';
    if (!best || score > best.score || (score === best.score && name < best.name)) {
      best = { slug: entry.slug, matched_term: entry.term, match_type: 'fuzzy', score, tried: needle, name };
    }
  }

  if (!best) return { slug: null, matched_term: null, match_type: 'none', score: 0, tried: needle };
  const { name, ...found } = best;
  return found;
}

/** Rattache toutes les lignes et y accroche la vérité annotée si elle existe. */
export function matchAll({
  index = buildIndex(),
  lines = loadLines(),
  expected = loadExpected(),
  field = 'item',
} = {}) {
  return lines.map((line) => {
    const found = matchItem(line[field], index);
    const truth = expected.get(`${line.recipe}#${line.index}`) ?? null;
    return {
      ...line,
      ...found,
      expected_slug: truth ? truth.expected_slug : null,
      verdict: verdictFor(found.slug, truth, index),
    };
  });
}

/**
 * Le verdict, et donc le chiffre du jalon.
 *
 *   ok      rattaché à ce qu'un humain aurait choisi
 *   coarse  rattaché au canonique dont l'annotation attendait une variante :
 *           moins précis, mais on part au bon rayon et on rentre avec le bon
 *           produit. Compté à part, jamais silencieusement avec les `ok`.
 *   wrong   rattaché à autre chose. Compte comme un échec, et c'est le pire
 *           des cas : le panier se remplit de travers sans rien signaler.
 *   absent  aucun rattachement, et l'annotation confirme qu'il n'y a rien à
 *           rattacher — l'ingrédient manque au référentiel
 *   miss    aucun rattachement alors que la cible existe
 */
export function verdictFor(slug, truth, index) {
  if (!truth) return 'unreviewed';
  if (truth.expected_slug === '-') return slug ? 'wrong' : 'absent';
  if (!slug) return 'miss';
  if (slug === truth.expected_slug) return 'ok';
  if (index?.bySlug.get(truth.expected_slug)?.parent_slug === slug) return 'coarse';
  return 'wrong';
}

/* ------------------------------------------------- annotation de référence */

export const EXPECTED_FILE = path.join(RECIPES_DIR, 'expected.psv');

/**
 * La vérité, relue à la main : pour chaque ligne, l'ingrédient du référentiel
 * qu'un humain aurait choisi, ou `-` si le référentiel n'a rien à offrir.
 * Sans ce fichier, la mesure ne saurait pas distinguer un bon rattachement
 * d'un mauvais, et le taux ne voudrait rien dire.
 */
export function loadExpected(file = EXPECTED_FILE) {
  const map = new Map();
  if (!fs.existsSync(file)) return map;

  const raw = fs.readFileSync(file, 'utf8');
  let header = null;
  for (const line of raw.split(/\r?\n/)) {
    if (!line.trim() || line.startsWith('#')) continue;
    const cells = line.split('|').map((c) => c.trim());
    if (!header) {
      header = cells;
      continue;
    }
    const row = Object.fromEntries(header.map((k, i) => [k, cells[i] ?? '']));
    map.set(`${row.recipe}#${row.line}`, {
      recipe: row.recipe,
      line: Number(row.line),
      item: row.item,
      expected_slug: row.expected_slug,
      note: row.note || null,
    });
  }
  return map;
}
