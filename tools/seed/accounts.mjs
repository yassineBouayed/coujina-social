/**
 * npm run seed:accounts — crée les trois comptes de connexion FICTIFS
 * (data/fictive/comptes-de-test.json) sur un projet Supabase DE TEST.
 *
 *   SUPABASE_URL=https://xxx.supabase.co SUPABASE_SERVICE_ROLE_KEY=... npm run seed:accounts
 *
 * Chaque compte reçoit l'identifiant de sa personne fictive : le profil, les
 * préférences, les recettes et les abonnements de fictive.generated.sql lui
 * appartiennent donc dès la première connexion. Refuse de tourner sur une URL
 * qui ne dit pas « test », « staging » ou « dev », sauf --force.
 */
import fs from 'node:fs';
import path from 'node:path';
import { ROOT, stableUuid } from './shared.mjs';

const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!url || !key) {
  console.error('SUPABASE_URL et SUPABASE_SERVICE_ROLE_KEY sont requis (projet de TEST).');
  process.exit(1);
}
if (!/test|staging|dev|localhost|127\.0\.0\.1/i.test(url) && !process.argv.includes('--force')) {
  console.error(`${url} ne ressemble pas à un projet de test. Relancer avec --force si c'en est un.`);
  process.exit(1);
}

const { password, comptes } = JSON.parse(fs.readFileSync(path.join(ROOT, 'data', 'fictive', 'comptes-de-test.json'), 'utf8'));

for (const c of comptes) {
  const res = await fetch(`${url.replace(/\/+$/, '')}/auth/v1/admin/users`, {
    method: 'POST',
    headers: { apikey: key, Authorization: `Bearer ${key}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({ id: stableUuid(`user:${c.key}`), email: c.email, password, email_confirm: true }),
  });
  const body = await res.json().catch(() => ({}));
  if (res.ok) console.log(`créé    ${c.email}`);
  else if (res.status === 422 || /already/i.test(JSON.stringify(body))) console.log(`existe  ${c.email}`);
  else {
    console.error(`ECHEC   ${c.email} : ${res.status} ${JSON.stringify(body)}`);
    process.exitCode = 1;
  }
}
