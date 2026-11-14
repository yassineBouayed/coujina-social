/**
 * Le socle de base de données de `db:test` — repris de l'ancien projet.
 * Ni Docker, ni CLI Supabase : sans `DATABASE_URL`, un PostgreSQL éphémère est
 * démarré par `embedded-postgres` et effacé à la sortie.
 */
import fs from 'node:fs';
import path from 'node:path';
import { ROOT } from './refdata/refdata.mjs';

export const MIGRATIONS_DIR = path.join(ROOT, 'supabase', 'migrations');
export const TESTS_DIR = path.join(ROOT, 'supabase', 'tests');
export const SEED_DIR = path.join(ROOT, 'supabase', 'seed');

/**
 * Les amorçages, dans l'ordre de leurs dépendances. La commande qui régénère
 * chacun est nommée ici, pour qu'un fichier absent dise quoi lancer.
 */
export const SEEDS = [
  { file: 'catalog.generated.sql', build: 'npm run seed:catalog' },
  // Les personnes fictives après le livre : elles en copient les recettes.
  { file: 'fictive.generated.sql', build: 'npm run seed:fictive' },
];

/** Sort en erreur — avec le nom de la commande à lancer — si un amorçage manque. */
export function requireSeeds(seeds = SEEDS) {
  for (const seed of seeds) {
    if (!fs.existsSync(path.join(SEED_DIR, seed.file))) {
      console.error(`Amorçage absent : supabase/seed/${seed.file}\nLancer d'abord : ${seed.build}`);
      process.exit(1);
    }
  }
}

const sqlFiles = (dir) => fs.readdirSync(dir).filter((f) => f.endsWith('.sql')).sort();

export const migrationFiles = () => sqlFiles(MIGRATIONS_DIR);
export const testFiles = () => sqlFiles(TESTS_DIR);

export const readMigration = (file) => fs.readFileSync(path.join(MIGRATIONS_DIR, file), 'utf8');
export const readTest = (file) => fs.readFileSync(path.join(TESTS_DIR, file), 'utf8');
export const readSeed = (file) => fs.readFileSync(path.join(SEED_DIR, file), 'utf8');

/**
 * Le fichier de test est écrit pour psql. Les méta-commandes s'enlèvent, sauf
 * les `\echo` qui portent le découpage en sections : ils deviennent des notices,
 * pour que la sortie d'ici se lise comme celle de psql.
 */
export function stripPsqlMeta(sql) {
  return sql
    .split('\n')
    .map((line) => {
      const echo = line.match(/^\s*\\echo\s+'(.*)'\s*$/);
      if (echo) return `do $jecho$ begin raise notice '%', $jmsg$${echo[1]}$jmsg$; end $jecho$;`;
      return /^\s*\\/.test(line) ? '' : line;
    })
    .join('\n');
}

/**
 * Le catalogue porte du grec, du cyrillique, de l'arabe, du japonais et des
 * drapeaux emoji dans `native_name` et `countries.flag`. Rien de tout cela
 * n'existe en WIN1252 — l'encodage que libpq deduit de la locale Windows —
 * et l'amorcage echoue alors sur le premier caractere venu, avec un message
 * qui ne dit pas d'ou il vient.
 *
 * Supabase sert en UTF-8. Le dire ici aligne la base de test sur la
 * production, au lieu de contraindre les donnees a tenir dans un jeu de
 * 256 caracteres.
 */
async function useUtf8(client) {
  await client.query("set client_encoding to 'UTF8'");
}

/**
 * Ouvre une base, passe le client à `run`, et referme quoi qu'il arrive.
 *
 * `port` et `cacheDir` sont paramétrés pour que deux outils puissent tourner
 * côte à côte sans se disputer le même répertoire de données.
 */
export async function withClient(run, { port = 54329, cacheDir = 'pgdata' } = {}) {
  const { default: pg } = await import('pg');

  if (process.env.DATABASE_URL) {
    const client = new pg.Client({ connectionString: process.env.DATABASE_URL });
    await client.connect();
    await useUtf8(client);
    console.log('Base : DATABASE_URL\n');
    try {
      return await run(client);
    } finally {
      await client.end();
    }
  }

  const { default: EmbeddedPostgres } = await import('embedded-postgres');
  const dataDir = path.join(ROOT, 'node_modules', '.cache', cacheDir);
  fs.rmSync(dataDir, { recursive: true, force: true });

  // `initdb` deduit l'encodage de la locale du systeme : sur un Windows
  // francais, il cree une base WIN1252, et TOUT le catalogue non latin —
  // le grec de la moussaka, le cyrillique du bortsch, le japonais, l'arabe,
  // les drapeaux de `countries` — devient ininserable. Supabase sert en
  // UTF-8 : la base de test doit en faire autant, sinon elle refuse des
  // donnees que la production accepte.
  const server = new EmbeddedPostgres({
    databaseDir: dataDir,
    user: 'postgres',
    password: 'postgres',
    port,
    persistent: false,
    initdbFlags: [
      '--encoding=UTF8',
      // La locale C ne connait que l'ASCII : `lower()` y laisse « Œuf »
      // intact, refdata_norm en tire « uf », et le rattachement de J2
      // diverge silencieusement entre la base et l'outil hors ligne.
      // Le fournisseur `builtin` de PostgreSQL 17+ fait la casse Unicode
      // complete sans dependre de la locale de la machine : le meme
      // resultat sur un Windows francais et sur la CI.
      '--locale-provider=builtin',
      '--builtin-locale=C.UTF-8',
    ],
  });

  console.log('Base : PostgreSQL éphémère (embedded-postgres)\n');
  await server.initialise();
  await server.start();
  const client = server.getPgClient();
  await client.connect();
  await useUtf8(client);

  try {
    // Les rôles que Supabase fournit et dont les policies dépendent.
    await client.query('create role anon nologin; create role authenticated nologin;');
    return await run(client);
  } finally {
    await client.end();
    await server.stop();
    fs.rmSync(dataDir, { recursive: true, force: true });
  }
}

/**
 * Migrations puis amorçages, en silence. `db:test` ne s'en sert pas : il
 * annonce chaque fichier et rejoue chaque amorçage une seconde fois pour
 * vérifier l'idempotence, ce qui est précisément son travail.
 */
export async function applySchema(client) {
  for (const file of migrationFiles()) await client.query(readMigration(file));
  for (const seed of SEEDS) await client.query(readSeed(seed.file));
}
