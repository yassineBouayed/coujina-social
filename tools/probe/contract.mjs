/**
 * Le contrat de sortie du générateur, vérifié recette par recette.
 *
 * Écrit au jalon J2 ([docs/format-recette.md]), extrait ici au jalon J5 parce
 * que deux outils l'appliquent désormais : `probe:validate`, sur le corpus figé
 * de la sonde, et `catalog:validate`, sur tout le catalogue. Une seconde copie
 * des règles aurait divergé le jour où l'une des deux aurait été corrigée.
 *
 * Le contrat n'a d'intérêt que s'il est vérifié : un générateur qui glisse la
 * préparation dans `item` fait chuter le taux de rattachement sans qu'on sache
 * pourquoi. C'est donc ici, et pas dans la mesure, qu'on attrape ce genre de
 * dérive.
 */
import { norm } from '../refdata/refdata.mjs';
import { MEAL_TYPES, DIFFICULTIES, RECIPE_UNITS } from './probe.mjs';

/**
 * Mots qui décrivent un geste plutôt qu'un achat, et qui font glisser
 * « oignon » vers « oignons émincés » — donc un rattachement exact vers un
 * repli flou.
 *
 * Ce n'est qu'un signalement, jamais un échec, et pour une raison de fond :
 * plusieurs de ces mots appartiennent à un nom de marché. On achète du
 * « bœuf haché », de la « noix de coco râpée », de la « tomate pelée en
 * conserve ». Un mot n'est une préparation que dans un libellé donné, ce que
 * seul le référentiel peut trancher — et quand il ne tranche pas, c'est la
 * mesure du rattachement qui dira si la ligne en a souffert.
 */
export const PREP_WORDS = [
  'emince', 'hache', 'cisele', 'rape', 'ecrase', 'coupe', 'pele', 'epluche',
  'denoyaute', 'egoutte', 'trempe', 'rince', 'battu', 'fondu', 'ramolli',
  'en des', 'en rondelle', 'en lamelle', 'en quartier', 'en morceau',
];

/**
 * Vérifie une recette contre le contrat. Renvoie les problèmes et les
 * avertissements ; ne décide de rien, et n'écrit rien.
 */
export function checkRecipe(recipe, { index, where = recipe.__path ?? recipe.__file } = {}) {
  const problems = [];
  const warnings = [];
  const fail = (at, message) => problems.push(`${at} : ${message}`);
  const warn = (at, message) => warnings.push(`${at} : ${message}`);
  const isReferentialTerm = (item) => index.byTerm.has(`fr:${norm(item)}`);

  /* --------------------------------------------------------------- entête */

  for (const field of ['slug', 'cuisine', 'native_name', 'title', 'meal_type', 'servings', 'status', 'source']) {
    if (recipe[field] === undefined) fail(where, `champ obligatoire absent : ${field}`);
  }

  if (recipe.slug && recipe.__file !== `${recipe.slug}.json`) {
    fail(where, `le fichier devrait s'appeler ${recipe.slug}.json`);
  }

  if (recipe.title && (!recipe.title.fr || !recipe.title.en)) {
    fail(where, 'le titre doit exister en français et en anglais (SPEC §4)');
  }
  if (recipe.meal_type && !MEAL_TYPES.includes(recipe.meal_type)) {
    fail(where, `meal_type inconnu : ${recipe.meal_type}`);
  }
  if (recipe.difficulty && !DIFFICULTIES.includes(recipe.difficulty)) {
    fail(where, `difficulté inconnue : ${recipe.difficulty}`);
  }
  if (!Number.isInteger(recipe.servings) || recipe.servings < 1) {
    fail(where, 'servings doit être un entier positif : la fiche est mise à l\'échelle par convive (SPEC §12)');
  }

  // SPEC §4 : le statut vérifié se gagne par relecture humaine. Un générateur
  // ne se décerne pas sa propre crédibilité.
  if (recipe.status !== 'unverified') {
    fail(where, `status doit valoir "unverified" à la génération, trouvé "${recipe.status}"`);
  }

  // SPEC §13 (J5) : les drapeaux sont hérités des ingrédients. Les déclarer ici
  // créerait une seconde source de vérité sur une donnée de sécurité.
  if (recipe.dietary_flags !== undefined) {
    fail(where, 'une recette ne déclare pas de drapeaux alimentaires : ils sont hérités des ingrédients');
  }

  /* ---------------------------------------------------------- ingrédients */

  if (!Array.isArray(recipe.ingredients) || recipe.ingredients.length === 0) {
    fail(where, 'aucun ingrédient');
    return { problems, warnings, lines: 0 };
  }

  recipe.ingredients.forEach((ingredient, i) => {
    const at = `${where}[${i}]`;

    if (!ingredient.item || typeof ingredient.item !== 'string') {
      fail(at, 'item manquant : c\'est le seul champ rattaché au référentiel');
      return;
    }
    if (!ingredient.raw) {
      warn(at, 'raw absent : la ligne ne compte pas dans la mesure du format non contraint');
    }
    if (ingredient.unit !== null && ingredient.unit !== undefined && !RECIPE_UNITS.includes(ingredient.unit)) {
      fail(at, `unité inconnue : ${ingredient.unit}`);
    }
    if (ingredient.qty !== null && ingredient.qty !== undefined && !(ingredient.qty > 0)) {
      fail(at, `quantité invalide : ${ingredient.qty}`);
    }
    if (ingredient.qty !== null && ingredient.qty !== undefined && (ingredient.unit === null || ingredient.unit === undefined)) {
      fail(at, `quantité ${ingredient.qty} sans unité`);
    }

    const item = norm(ingredient.item);
    if (!isReferentialTerm(ingredient.item)) {
      for (const word of PREP_WORDS) {
        if (item.includes(word)) {
          warn(at, `"${ingredient.item}" ressemble à une préparation et n'est pas un nom du référentiel`);
          break;
        }
      }
    }
    if (/^[0-9]/.test(item)) fail(at, `item commence par un nombre : "${ingredient.item}"`);

    for (const sub of ingredient.substitutes ?? []) {
      if (!sub.item) fail(at, 'un substitut sans item');
      if (!sub.note) fail(at, `substitut "${sub.item}" sans note : SPEC §3 exige de dire ce que le remplacement change`);
    }
  });

  const items = recipe.ingredients.map((i) => norm(i.item ?? '')).filter(Boolean);
  const duplicates = items.filter((it, i) => items.indexOf(it) !== i && items.lastIndexOf(it) === i);
  for (const duplicate of new Set(duplicates)) {
    // Légitime quand les deux lignes vivent dans des groupes différents
    // (le paprika de la kefta n'est pas celui de la sauce), suspect sinon.
    const groups = new Set(
      recipe.ingredients.filter((i) => norm(i.item ?? '') === duplicate).map((i) => i.group ?? ''),
    );
    if (groups.size === 1) warn(where, `"${duplicate}" apparaît deux fois dans le même groupe`);
  }

  /* --------------------------------------------------------------- étapes */

  if (!Array.isArray(recipe.steps) || recipe.steps.length === 0) {
    fail(where, 'aucune étape');
  } else {
    recipe.steps.forEach((step, i) => {
      if (!step.fr || !step.en) fail(`${where} étape ${i + 1}`, 'les étapes doivent exister en fr et en en');
    });
  }

  for (const [i, note] of (recipe.notes ?? []).entries()) {
    if (!note.fr || !note.en) fail(`${where} note ${i + 1}`, 'les notes doivent exister en fr et en en');
  }

  return { problems, warnings, lines: recipe.ingredients.length };
}

/** Applique le contrat à un lot, et agrège. */
export function checkAll(recipes, { index }) {
  const problems = [];
  const warnings = [];
  const slugs = new Set();
  let lines = 0;

  for (const recipe of recipes) {
    if (slugs.has(recipe.slug)) {
      problems.push(`${recipe.__path ?? recipe.__file} : slug en double : ${recipe.slug}`);
    }
    slugs.add(recipe.slug);

    const result = checkRecipe(recipe, { index });
    problems.push(...result.problems);
    warnings.push(...result.warnings);
    lines += result.lines;
  }

  return { problems, warnings, lines };
}
