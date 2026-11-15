/** La vérification de l'en-tête `Stripe-Signature`, à part pour être testée sans démarrer le serveur. */

/** Tolérance de Stripe sur l'horodatage de la signature : 5 minutes. */
const TOLERANCE_S = 300;

const hex = (buf: ArrayBuffer) => [...new Uint8Array(buf)].map((b) => b.toString(16).padStart(2, '0')).join('');

/** Comparaison à temps constant, pour ne rien laisser deviner de la signature. */
function equal(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

/** Vérifie l'en-tête `Stripe-Signature` (t=…, v1=…) : HMAC-SHA256 de `t.corps`. */
export async function verifyStripeSignature(body: string, header: string | null, secret: string, now = Date.now()): Promise<boolean> {
  if (!header) return false;
  const parts = Object.fromEntries(
    header.split(',').map((p) => p.split('=') as [string, string]).filter((p) => p.length === 2),
  );
  const t = Number(parts.t);
  const v1s = header.split(',').filter((p) => p.startsWith('v1=')).map((p) => p.slice(3));
  if (!t || !v1s.length || Math.abs(now / 1000 - t) > TOLERANCE_S) return false;
  const key = await crypto.subtle.importKey('raw', new TextEncoder().encode(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const expected = hex(await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(`${t}.${body}`)));
  return v1s.some((v) => equal(v, expected));
}
