# Fonctions Edge

## push-dispatch — les notifications push

Vide `notification_outbox` vers le service Expo. Les règles (trois cas, une
notification regroupée par 20 heures, rien entre 21 h et 9 h, réglages du
profil) sont en SQL : `notification_drain()`, migration
`20261116140000_notifications.sql`, test `13_notifications_test.sql`.

```bash
supabase functions deploy push-dispatch --no-verify-jwt
```

Puis, dans l'éditeur SQL du projet (extensions `pg_cron` et `pg_net` activées
dans *Database → Extensions*), l'appeler toutes les 15 minutes :

```sql
select cron.schedule(
  'coujina-push-dispatch',
  '*/15 * * * *',
  $$ select net.http_post(
       url := 'https://<projet>.supabase.co/functions/v1/push-dispatch',
       headers := jsonb_build_object('Authorization', 'Bearer <clé service_role>')
     ) $$
);
```

Le défi du lundi entre dans la file tout seul : la migration planifie
`enqueue_weekly_challenge()` le lundi à 9 h UTC quand `pg_cron` est présent.
Si l'extension a été activée après `supabase db push`, lancer une fois :

```sql
select cron.schedule('coujina-weekly-challenge', '0 9 * * 1', 'select enqueue_weekly_challenge()');
```

Les jetons des téléphones arrivent par `register_push_token()`, appelée par
l'application après la première recette enregistrée (jamais au premier
lancement : on demande la permission quand elle a un sens).

## stripe-webhook — la précommande Premium

Reçoit `checkout.session.completed` de Stripe, vérifie la signature
(`STRIPE_WEBHOOK_SECRET`, testée par `deno task test`), puis appelle
`record_preorder_payment()` : un an de Premium, idempotent.

```bash
supabase functions deploy stripe-webhook --no-verify-jwt
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_...
```

Le pas-à-pas Stripe (produit, lien de paiement, webhook) est dans
[docs/mise-en-production.md](../../docs/mise-en-production.md).
