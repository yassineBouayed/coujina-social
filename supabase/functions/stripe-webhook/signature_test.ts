// deno test supabase/functions/stripe-webhook/signature_test.ts
// La vérification de signature : un vrai webhook passe, un faux ou un vieux non.
import { verifyStripeSignature } from './signature.ts';

const secret = 'whsec_test_coujina';
const body = '{"type":"checkout.session.completed"}';

async function sign(t: number, payload: string, key = secret) {
  const k = await crypto.subtle.importKey('raw', new TextEncoder().encode(key), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const sig = await crypto.subtle.sign('HMAC', k, new TextEncoder().encode(`${t}.${payload}`));
  return [...new Uint8Array(sig)].map((b) => b.toString(16).padStart(2, '0')).join('');
}

function assert(cond: boolean, msg: string) {
  if (!cond) throw new Error(msg);
}

Deno.test('signature Stripe valide acceptée', async () => {
  const t = Math.floor(Date.now() / 1000);
  assert(await verifyStripeSignature(body, `t=${t},v1=${await sign(t, body)}`, secret), 'refusée');
});

Deno.test('corps modifié refusé', async () => {
  const t = Math.floor(Date.now() / 1000);
  assert(!(await verifyStripeSignature(body + ' ', `t=${t},v1=${await sign(t, body)}`, secret)), 'acceptée');
});

Deno.test('mauvais secret refusé', async () => {
  const t = Math.floor(Date.now() / 1000);
  assert(!(await verifyStripeSignature(body, `t=${t},v1=${await sign(t, body, 'whsec_autre')}`, secret)), 'acceptée');
});

Deno.test('signature trop vieille refusée (rejeu)', async () => {
  const t = Math.floor(Date.now() / 1000) - 3600;
  assert(!(await verifyStripeSignature(body, `t=${t},v1=${await sign(t, body)}`, secret)), 'acceptée');
});

Deno.test('en-tête absent refusé', async () => {
  assert(!(await verifyStripeSignature(body, null, secret)), 'acceptée');
});
