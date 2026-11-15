/**
 * npm run images:credits  ->  data/images/credits.json + data/images/a-revoir.csv
 *
 * Pour chaque photo candidate de data/plats-images.txt, demande à Wikimedia
 * Commons sa licence, son auteur et une version réduite (800 px). Puis :
 *
 *   - LICENCE : une photo n'est gardée que sous une licence qui permet l'usage
 *     commercial et la reproduction telle quelle avec crédit (domaine public,
 *     CC0, CC BY, CC BY-SA). NC, ND, GFDL seule, licence inconnue : retirée.
 *   - PERTINENCE : aucune machine ne sait si une photo montre le bon plat. On
 *     compare les mots du nom de fichier et de la description Commons à ceux
 *     de la recette, et l'on range la photo en trois cas :
 *       ok         un mot propre au plat en commun (« tajine », « jollof »)
 *       probable   seulement des mots génériques (« riz », « soupe »), ou la
 *                  même photo pour deux plats : AFFICHÉE, mais listée à revoir
 *       a-revoir   aucun mot commun, ou la même photo pour trois plats ou
 *                  plus : MASQUÉE tant qu'un humain ne l'a pas validée
 *                  (data/images/valide.txt, un slug par ligne).
 *
 * Ce que l'outil ne prouve pas : qu'une photo « pertinente » est la bonne. Il
 * écarte seulement les erreurs flagrantes (« Flan coco » illustré par un
 * halo-halo) ; la relecture humaine reste à faire pour les autres.
 */
import fs from 'node:fs';
import path from 'node:path';

import { ROOT, norm } from '../refdata/refdata.mjs';
import { loadBook } from '../seed/shared.mjs';
import { similarity } from '../probe/normalize.mjs';

const OUT_DIR = path.join(ROOT, 'data', 'images');
const API = 'https://commons.wikimedia.org/w/api.php';
const UA = 'coujina-social-credits/0.1 (https://github.com/yassineBouayed/coujina-social)';
const BATCH = 50;

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const stripHtml = (s) =>
  String(s ?? '').replace(/<[^>]*>/g, ' ').replace(/&amp;/g, '&').replace(/&quot;/g, '"').replace(/&#0?39;/g, "'")
    .replace(/&nbsp;/g, ' ').replace(/\s+/g, ' ').trim();

/** Licences qui autorisent un usage commercial, sans modification, avec crédit. */
export function licenseVerdict(shortName) {
  const l = String(shortName ?? '').toLowerCase();
  if (!l) return { ok: false, reason: 'licence inconnue' };
  if (/\bnc\b|non-?commercial/.test(l)) return { ok: false, reason: 'usage commercial interdit (NC)' };
  if (/\bnd\b|no ?deriv/.test(l)) return { ok: false, reason: 'modification interdite (ND)' };
  if (/public domain|^pd\b|^pd-|cc0|cc-zero|no restrictions|copyrighted free use/.test(l)) return { ok: true, attribution: false };
  // CC BY, CC BY-SA, Licence Art Libre (FAL) et licence publique coréenne de type 1 :
  // usage commercial permis, crédit obligatoire. La GFDL seule reste refusée :
  // elle exige de joindre le texte entier de la licence à chaque reproduction.
  if (/cc[ -]by|^fal\b|free art|kogl type 1/.test(l)) return { ok: true, attribution: true };
  return { ok: false, reason: `licence non retenue : ${shortName}` };
}

/** « baguettes » et « baguette », « tajines » et « tajine » : une même racine. */
const stem = (w) => w.replace(/[sx]$/, '').replace(/e$/, '');

// Les mots qui ne disent rien d'un plat.
const STOP = new Set(`de du des la le les au aux a l d et en un une sur avec sans pour par the of and with in on a an
jpg jpeg png file img dsc photo image cropped homemade plat dish food cuisine recette recipe`.split(/\s+/));
const words = (s) => norm(s).split(' ').filter((w) => w.length > 2 && !/^\d+$/.test(w) && !STOP.has(w)).map(stem);

// Des mots communs à trop de plats pour prouver qu'une photo montre le bon.
const GENERIC = new Set(`rice riz soup soupe salad salade fish poisson potato pomme pork porc beef boeuf stew ragout egg oeuf
fried frit milk lait coconut coco curry sauce bread pain chocolate chocolat coffee cafe tea the red rouge green vert meat viande
cake gateau bean haricot cheese fromage pudding con hot grilled grille chicken poulet noodle nouille carrot carotte
stuffed farci sweet sucre dessert juice jus drink boisson spicy epice white blanc black noir style traditional`.split(/\s+/).map(stem));

/**
 * Les mots du plat retrouvés dans un texte de la photo. Même racine, ou mots
 * de 5 lettres et plus presque identiques (« calalou » / « callaloo »).
 */
function overlap(recipe, photoText) {
  const photo = [...new Set(words(photoText))];
  const mine = new Set(
    [recipe.title, recipe.title_en, recipe.native_name, recipe.slug.replace(/-/g, ' ')].flatMap((s) => words(s ?? '')),
  );
  return [...mine].filter((w) => photo.some((p) => p === w || (w.length >= 5 && p.length >= 5 && similarity(p, w) >= 0.4)));
}

async function query(titles) {
  const url = `${API}?${new URLSearchParams({
    action: 'query', format: 'json', formatversion: '2', prop: 'imageinfo',
    iiprop: 'extmetadata|url', iiurlwidth: '800', titles: titles.join('|'),
  })}`;
  for (let attempt = 1; ; attempt++) {
    const res = await fetch(url, { headers: { 'User-Agent': UA } });
    if (res.ok) return res.json();
    if (attempt >= 4) throw new Error(`Commons ${res.status}`);
    await sleep(2000 * attempt);
  }
}

const book = loadBook();
const bySlug = new Map(book.map((r) => [r.slug, r]));
const byTitle = new Map(book.map((r) => [r.title, r]));

// Les candidates : titre français -> URL Commons.
const candidates = [];
for (const line of fs.readFileSync(path.join(ROOT, 'data', 'plats-images.txt'), 'utf8').split(/\r?\n/)) {
  const [title, url] = line.split('\t');
  const recipe = byTitle.get((title ?? '').trim());
  if (!recipe || !url?.startsWith('https://upload.wikimedia.org/')) continue;
  const file = decodeURIComponent(url.trim().split('/').pop()).replace(/_/g, ' ');
  candidates.push({ slug: recipe.slug, file: `File:${file}`, original: url.trim() });
}

const valid = new Set(
  fs.existsSync(path.join(OUT_DIR, 'valide.txt'))
    ? fs.readFileSync(path.join(OUT_DIR, 'valide.txt'), 'utf8').split(/\r?\n/).map((s) => s.trim()).filter(Boolean)
    : [],
);

const info = new Map();
const files = [...new Set(candidates.map((c) => c.file))];
for (let i = 0; i < files.length; i += BATCH) {
  const chunk = files.slice(i, i + BATCH);
  const json = await query(chunk);
  const renamed = new Map((json.query?.normalized ?? []).map((n) => [n.to, n.from]));
  for (const page of json.query?.pages ?? []) {
    const asked = renamed.get(page.title) ?? page.title;
    info.set(asked, page);
  }
  process.stdout.write(`\r${Math.min(i + BATCH, files.length)}/${files.length} fichiers interrogés`);
  await sleep(300);
}
process.stdout.write('\n');

// Combien de plats se partagent chaque fichier.
const sharing = new Map();
for (const c of candidates) sharing.set(c.file, (sharing.get(c.file) ?? 0) + 1);

const credits = {};
const review = [];
for (const c of candidates) {
  const page = info.get(c.file);
  const ii = page?.imageinfo?.[0];
  const m = ii?.extmetadata ?? {};
  const recipe = bySlug.get(c.slug);
  const license = m.LicenseShortName?.value ?? null;
  const verdict = page?.missing || !ii ? { ok: false, reason: 'fichier introuvable sur Commons' } : licenseVerdict(license);
  const artist = stripHtml(m.Artist?.value) || stripHtml(m.Credit?.value) || 'auteur inconnu';
  // Le titre de la photo (nom de fichier, nom de l'objet) fait foi ; sa
  // description, plus bavarde, ne suffit jamais seule : celle du halo-halo
  // parle de flan et de coco, et la photo illustrait un « flan coco ».
  const inTitle = overlap(recipe, `${c.file} ${stripHtml(m.ObjectName?.value)}`);
  const inText = overlap(recipe, `${stripHtml(m.ImageDescription?.value)} ${stripHtml(m.Categories?.value)}`);
  const specific = inTitle.filter((w) => !GENERIC.has(w));
  const common = [...new Set([...inTitle, ...inText])];
  const shared = sharing.get(c.file);
  // « Map of Berber languages » pour le berbéré : un nom qui colle, une image qui n'est pas un plat.
  const notAPhoto = /\.(svg|gif)$/i.test(c.file) || /\b(map|carte|flag|drapeau|logo|diagram|locator|coat of arms)\b/i.test(c.file);

  let status = 'ok';
  let reason = null;
  if (!verdict.ok) { status = 'retiree'; reason = verdict.reason; }
  else if (valid.has(c.slug)) { status = 'ok'; }
  else if (notAPhoto) { status = 'a-revoir'; reason = "ce n'est pas une photo de plat (carte, drapeau, logo…)"; }
  else if (shared >= 3) { status = 'a-revoir'; reason = `la même photo sert pour ${shared} plats`; }
  else if (!inTitle.length) {
    status = 'a-revoir';
    reason = inText.length ? `rien dans le titre de la photo ; seulement sa description : ${inText.join(', ')}` : 'aucun mot commun entre la photo et le plat';
  }
  else if (!specific.length) { status = 'probable'; reason = `seulement des mots génériques en commun : ${inTitle.join(', ')}`; }
  else if (shared === 2) { status = 'probable'; reason = 'la même photo sert pour 2 plats'; }

  credits[c.slug] = {
    status,
    reason,
    file: c.file,
    source: ii?.descriptionurl ?? null,
    url: (ii?.thumburl ?? ii?.url ?? c.original).split('?')[0],
    license,
    license_url: m.LicenseUrl?.value ?? null,
    artist: artist.slice(0, 160),
    // Le crédit tel qu'il s'affiche sous la photo.
    credit: verdict.ok ? `Photo : ${artist.slice(0, 120)} — ${license}, via Wikimedia Commons` : null,
    matched: common,
  };
  if (status !== 'ok') review.push([c.slug, recipe.title, status, reason, ii?.descriptionurl ?? c.original]);
}

fs.mkdirSync(OUT_DIR, { recursive: true });
fs.writeFileSync(path.join(OUT_DIR, 'credits.json'), JSON.stringify(credits, null, 1) + '\n');
const csv = (v) => `"${String(v ?? '').replace(/"/g, '""')}"`;
fs.writeFileSync(
  path.join(OUT_DIR, 'a-revoir.csv'),
  ['slug,plat,statut,raison,page Commons', ...review.sort((a, b) => a[2].localeCompare(b[2]) || a[0].localeCompare(b[0])).map((r) => r.map(csv).join(','))].join('\n') + '\n',
);

const count = (s) => Object.values(credits).filter((c) => c.status === s).length;
console.log(`${candidates.length} photos : ${count('ok')} sûres, ${count('probable')} probables (affichées, à relire), ${count('a-revoir')} masquées en attente de relecture, ${count('retiree')} retirées (licence)`);
console.log('-> data/images/credits.json, data/images/a-revoir.csv');
