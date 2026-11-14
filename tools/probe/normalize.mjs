/**
 * Étape de normalisation intermédiaire (jalon J2).
 *
 * Entre le champ `item` d'une recette générée et le référentiel, il manque un
 * pas : « oignons » n'est pas « oignon », « collier d'agneau » n'existe pas mais
 * « agneau » oui. Ce module produit, pour un libellé, la liste ordonnée des
 * formes sous lesquelles il vaut la peine de l'essayer.
 *
 * Deux règles gouvernent ce fichier :
 *
 *   1. **Déterministe et sans modèle.** Un rattachement qui demanderait un
 *      second appel au générateur ne serait pas automatique au sens du critère
 *      de sortie. Tout ici est une table de mots et une boucle.
 *
 *   2. **Miroir exact de `refdata_term_candidates()` côté SQL**, comme `norm()`
 *      l'est de `refdata_norm()`. La mesure du jalon est faite par la base ;
 *      cet outil doit trouver la même chose, et `npm run db:test` le vérifie
 *      ligne à ligne.
 *
 * L'ordre des formes n'est pas cosmétique : il va du plus précis au moins
 * précis, et on s'arrête à la première qui rattache. C'est ce qui évite qu'un
 * « tomate concassée en conserve » soit dégradé en « tomate » alors que la
 * variante exacte existe.
 */
import { norm } from '../refdata/refdata.mjs';

/* ------------------------------------------------------------- vocabulaire */

/** Articles et prépositions : ne portent jamais de sens d'ingrédient. */
const ARTICLES = new Set(['de', 'du', 'des', 'd', 'le', 'la', 'les', 'l', 'un', 'une', 'au', 'aux', 'a']);

/**
 * Qualificatifs de taille et de qualité. Aucun ne distingue deux ingrédients
 * du référentiel — c'est le critère d'entrée dans cette liste, et la raison
 * pour laquelle `moulu`, `sec`, `frais`, `vert`, `rouge`, `fine` ou `confit`
 * n'y sont PAS : ils séparent « cannelle » de « cannelle moulue »,
 * « fève sèche » de « fève fraîche », « olive verte » de « olive noire ».
 */
const DESCRIPTORS = new Set([
  'gros', 'grosse', 'grand', 'grande', 'petit', 'petite', 'moyen', 'moyenne',
  'beau', 'belle', 'bien', 'mur', 'mure', 'environ', 'bio', 'extra',
  'large', 'medium', 'small', 'big', 'ripe', 'good', 'quality',
]);

/** Pluriels irréguliers ou mots à finale trompeuse : on ne les singularise pas. */
const NO_SINGULAR = new Set([
  'anis', 'couscous', 'ras', 'cas', 'os', 'riz', 'gras', 'jus', 'pois', 'maïs', 'mais',
  'epices', 'herbes', 'petits', 'cress', 'grains',
]);

/* --------------------------------------------------------------- singulier */

/**
 * Singulier grossier, mot à mot. Il ne cherche pas à être une grammaire :
 * il cherche à ce que « oignons » et « tomates » retombent sur leur entrée.
 * `petits pois` est protégé par NO_SINGULAR, sinon il deviendrait `petit poi`.
 */
export function singularize(text) {
  return text
    .split(' ')
    .map((word) => {
      if (word.length <= 3 || NO_SINGULAR.has(word)) return word;
      if (word.endsWith('eaux')) return `${word.slice(0, -1)}`;   // gateaux -> gateau
      if (word.endsWith('aux')) return `${word.slice(0, -3)}al`;  // vegetaux -> vegetal
      if (word.endsWith('x') || word.endsWith('s')) return word.slice(0, -1);
      return word;
    })
    .join(' ');
}

/** Retire articles et qualificatifs de taille, où qu'ils soient dans le libellé. */
export function stripFillers(text) {
  const kept = text.split(' ').filter((w) => w && !ARTICLES.has(w) && !DESCRIPTORS.has(w));
  return kept.join(' ');
}

/* -------------------------------------------------------------- candidats */

/**
 * Sous-suites contiguës du libellé, de la plus longue à la plus courte, sans
 * celles qui ne sont faites que d'articles. Sert de repli générique : quand la
 * découpe demandée par la recette n'existe pas au référentiel (« collier
 * d'agneau »), on remonte à ce qui existe (« agneau »).
 *
 * C'est une dégradation de précision, jamais une équivalence : le rapport la
 * compte à part, sous le type `generic`.
 */
function spans(text) {
  const words = text.split(' ').filter(Boolean);
  const out = [];
  for (let size = words.length - 1; size >= 1; size -= 1) {
    for (let start = 0; start + size <= words.length; start += 1) {
      const span = words.slice(start, start + size);
      if (span.every((w) => ARTICLES.has(w))) continue;
      out.push(span.join(' '));
    }
  }
  return out;
}

/**
 * Les formes à essayer, dans l'ordre, avec le type de rattachement que chacune
 * produirait. Sans doublon : la première occurrence gagne, donc le type le plus
 * précis.
 */
export function termCandidates(item) {
  const base = norm(item);
  const list = [
    { term: base, kind: 'exact' },
    { term: singularize(base), kind: 'singular' },
    { term: stripFillers(singularize(base)), kind: 'stripped' },
    ...spans(stripFillers(singularize(base))).map((term) => ({ term, kind: 'generic' })),
  ];

  const seen = new Set();
  return list.filter(({ term }) => {
    if (!term || seen.has(term)) return false;
    seen.add(term);
    return true;
  });
}

/* --------------------------------------------------------------- unités */

/**
 * Le référentiel ne connaît que sept unités ; le format de recette en accepte
 * dix, parce qu'un générateur écrit « 1,2 kg » et non « 1200 g ». La conversion
 * est ici, une fois, plutôt que dans chaque consommateur.
 */
const UNIT_SCALE = { kg: ['g', 1000], cl: ['ml', 10], l: ['ml', 1000] };

export function normalizeUnit(qty, unit) {
  const rule = UNIT_SCALE[unit];
  if (!rule) return { qty, unit };
  const [target, factor] = rule;
  return { qty: qty === null ? null : Math.round(qty * factor * 1000) / 1000, unit: target };
}

/* ------------------------------------------------------------- trigrammes */

/**
 * Trigrammes de pg_trgm : chaque mot est bordé de deux espaces devant et un
 * derrière. Reproduit ici pour que le repli flou mesuré hors ligne soit celui
 * que la base appliquera, et non une approximation qui flatterait le taux.
 */
export function trigrams(text) {
  const set = new Set();
  for (const word of text.split(' ').filter(Boolean)) {
    const padded = `  ${word} `;
    for (let i = 0; i + 3 <= padded.length; i += 1) set.add(padded.slice(i, i + 3));
  }
  return set;
}

/** similarity() de pg_trgm : intersection sur union des trigrammes. */
export function similarity(a, b) {
  const ta = trigrams(a);
  const tb = trigrams(b);
  if (ta.size === 0 || tb.size === 0) return 0;
  let shared = 0;
  for (const t of ta) if (tb.has(t)) shared += 1;
  return shared / (ta.size + tb.size - shared);
}
