/**
 * npm run db:test                     PostgreSQL éphémère, rien à installer
 * DATABASE_URL=... npm run db:test    contre une base existante
 *
 * Applique les migrations, charge les deux amorçages DEUX fois (l'idempotence
 * est vérifiée, pas supposée), puis joue tous les fichiers de supabase/tests/.
 * Chaque test se termine par un ROLLBACK : rien n'est laissé derrière.
 */
import {
  SEEDS, migrationFiles, readMigration, readSeed, readTest, requireSeeds, stripPsqlMeta, testFiles, withClient,
} from './db.mjs';

requireSeeds();

async function step(client, label, sql) {
  try {
    await client.query(sql);
    console.log(`ok    ${label}`);
  } catch (error) {
    console.error(`ECHEC ${label}`);
    console.error(`      ${error.message}`);
    if (error.where) console.error(`      ${error.where}`);
    throw error;
  }
}

const exitCode = await withClient(async (client) => {
  client.on('notice', (n) => console.log(`      ${n.message}`));

  for (const file of migrationFiles()) await step(client, `migration ${file}`, readMigration(file));

  for (const seed of SEEDS) {
    const sql = readSeed(seed.file);
    await step(client, `amorçage ${seed.file}`, sql);
    await step(client, `amorçage ${seed.file} rejoué (idempotence)`, sql);
  }

  const { rows } = await client.query(`select
    (select count(*) from recipes where slug is not null)::int as livre,
    (select count(*) from profiles where not is_editorial)::int as personnes,
    (select count(*) from recipe_copies)::int as copies,
    (select count(*) from follows)::int as abonnements`);
  const r = rows[0];
  console.log(`      ${r.livre} recettes du livre, ${r.personnes} personnes fictives, ${r.copies} copies, ${r.abonnements} abonnements\n`);

  for (const file of testFiles()) await step(client, file, stripPsqlMeta(readTest(file)));

  console.log('\nTous les tests SQL passent.');
  return 0;
}, { cacheDir: 'db-test-pgdata' });

process.exit(exitCode);
