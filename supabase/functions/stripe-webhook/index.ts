/**
 * stripe-webhook — reçoit la confirmation d'une précommande payée.
 *
 * L'application ouvre un lien de paiement Stripe avec
 * `?client_reference_id=<id du profil>`. Quand Stripe confirme le paiement
 * (`checkout.session.completed`, payé), cette fonction vérifie la signature
 * de Stripe, puis appelle `record_preorder_payment()` : un an de Premium,
 * une ligne dans `preorders`, idempotent si Stripe renvoie l'évènement.
 *
 * Secrets : STRIPE_WEBHOOK_SECRET (Stripe → Développeurs → Webhooks).
 * Déploiement : supabase/functions/README.md.
 */
import { createClient } from 'jsr:@supabase/supabase-js@2';

import { verifyStripeSignature } from './signature.ts';

const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

Deno.serve(async (request) => {
  if (request.method !== 'POST') return new Response('method not allowed', { status: 405 });

  const body = await request.text();
  const ok = await verifyStripeSignature(body, request.headers.get('stripe-signature'), Deno.env.get('STRIPE_WEBHOOK_SECRET') ?? '');
  if (!ok) return new Response('bad signature', { status: 400 });

  const event = JSON.parse(body);
  if (event.type !== 'checkout.session.completed') return Response.json({ ignored: event.type });

  const session = event.data?.object ?? {};
  const profile = session.client_reference_id;
  if (session.payment_status !== 'paid' || !UUID.test(profile ?? '')) {
    // Payé sans profil : à rapprocher à la main dans Stripe (e-mail du client).
    console.error('session without profile or not paid', session.id, session.payment_status);
    return Response.json({ recorded: false });
  }

  const supabase = createClient(Deno.env.get('SUPABASE_URL')!, Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!, {
    auth: { persistSession: false },
  });
  const { data, error } = await supabase.rpc('record_preorder_payment', {
    p_profile: profile,
    p_session: session.id,
    p_amount_cents: session.amount_total,
    p_currency: session.currency ?? 'eur',
  });
  if (error) {
    console.error('record failed', error);
    // 500 : Stripe réessaiera.
    return Response.json({ error: error.message }, { status: 500 });
  }
  return Response.json({ recorded: data === true });
});
