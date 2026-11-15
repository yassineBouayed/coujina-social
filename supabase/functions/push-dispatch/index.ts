/**
 * push-dispatch — vide la file `notification_outbox` vers le service Expo.
 *
 * Reprise de l'ancien projet. Toutes les règles (une par jour, regroupée,
 * jamais la nuit, réglages du profil) vivent dans `notification_drain()` en
 * SQL, testées par supabase/tests/13_notifications_test.sql ; cette fonction
 * ne fait que transporter, et oublie les jetons qu'Expo déclare morts.
 *
 * Déploiement et planification : supabase/functions/README.md.
 */
import { createClient } from 'jsr:@supabase/supabase-js@2';

type Message = {
  outbox_ids: number[];
  recipient_id: string;
  expo_token: string;
  title: string;
  body: string;
  data: Record<string, unknown>;
};

const EXPO_ENDPOINT = 'https://exp.host/--/api/v2/push/send';
/** Expo accepte cent messages par requête. */
const BATCH = 100;

Deno.serve(async (_request) => {
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    { auth: { persistSession: false } },
  );

  const { data, error } = await supabase.rpc('notification_drain', { p_limit: 200 });
  if (error) {
    console.error('drain failed', error);
    return Response.json({ error: error.message }, { status: 500 });
  }

  const messages = (data ?? []) as Message[];
  if (messages.length === 0) return Response.json({ sent: 0, invalid: 0 });

  const invalid: string[] = [];
  let sent = 0;

  for (let i = 0; i < messages.length; i += BATCH) {
    const slice = messages.slice(i, i + BATCH);
    const response = await fetch(EXPO_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
      body: JSON.stringify(
        slice.map((m) => ({ to: m.expo_token, title: m.title, body: m.body, data: m.data, sound: null })),
      ),
    });

    if (!response.ok) {
      console.error('expo rejected a batch', response.status, await response.text());
      continue;
    }

    const payload = await response.json();
    const tickets: { status: string; details?: { error?: string } }[] = payload.data ?? [];
    tickets.forEach((ticket, index) => {
      if (ticket.status === 'ok') {
        sent += 1;
      } else if (ticket.details?.error === 'DeviceNotRegistered') {
        invalid.push(slice[index].expo_token);
      } else {
        console.error('expo ticket error', ticket);
      }
    });
  }

  if (invalid.length > 0) {
    await supabase.from('push_devices').delete().in('expo_token', invalid);
  }

  return Response.json({ sent, invalid: invalid.length });
});
