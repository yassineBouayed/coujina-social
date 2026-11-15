/**
 * npm run beta:report — les chiffres du test à 20 cuisiniers.
 *
 *   DATABASE_URL=postgres://… npm run beta:report
 *
 * Lit beta_metrics() avec les droits de la base (la fonction est fermée aux
 * utilisateurs de l'application). Les testeurs se déclarent une fois, en SQL :
 *
 *   insert into beta_testers (profile_id, note)
 *   select id, 'recrutée au marché de …' from profiles where username = '…';
 *
 * Voir docs/beta-20-cuisiniers.md pour le protocole et les seuils.
 */
const url = process.env.DATABASE_URL;
if (!url) {
  console.error('DATABASE_URL est requis (la chaîne de connexion du projet Supabase, onglet Database).');
  process.exit(1);
}

const { default: pg } = await import('pg');
const client = new pg.Client({ connectionString: url });
await client.connect();
try {
  await client.query("set client_encoding to 'UTF8'");
  const { rows } = await client.query('select metric, value, detail from beta_metrics()');
  const width = Math.max(...rows.map((r) => r.metric.length));
  console.log(`Bêta couJina — ${new Date().toLocaleDateString('fr-FR')}\n`);
  for (const r of rows) console.log(`${r.metric.padEnd(width)}  ${r.value}${r.detail ? `   (${r.detail})` : ''}`);
} finally {
  await client.end();
}
