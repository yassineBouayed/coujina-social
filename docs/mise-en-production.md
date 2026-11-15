# Mettre couJina sur un vrai serveur et un vrai téléphone

> Ce que l'Operator Shark attend avant tout le reste. Semaines du 16 et 23/11
> dans [planning-heures.md](planning-heures.md). Rien de tout cela n'a encore été fait.

## 1. Supabase (≈ 2 h)

1. Créer le projet **dans une région de l'UE** (Francfort ou Paris si proposée).
2. `supabase link --project-ref <ref>` puis `supabase db push`.
3. Charger le livre : `psql "$DATABASE_URL" -f supabase/seed/catalog.generated.sql`
   (**pas** les données fictives en production).
4. *Authentication → Providers* : Email (confirmation activée, modèle d'e-mail
   avec `{{ .Token }}`), Google, Apple ; *URL Configuration* :
   `coujinasocial://auth-callback`.
5. *Database → Extensions* : `pg_cron`, `pg_net`.

## 2. Fonctions (≈ 1 h)

```bash
supabase functions deploy push-dispatch --no-verify-jwt
supabase functions deploy stripe-webhook --no-verify-jwt
supabase secrets set STRIPE_WEBHOOK_SECRET=whsec_…
```

Puis planifier `push-dispatch` (voir [supabase/functions/README.md](../supabase/functions/README.md)).

## 3. Stripe (≈ 1 h)

1. Créer un produit « couJina Premium — 1 an », **29 € TTC, paiement unique**.
2. Créer un **lien de paiement** pour ce produit ; activer « Après le paiement →
   ne pas afficher de page de confirmation » ou une page de retour simple.
3. *Développeurs → Webhooks* : point de terminaison
   `https://<projet>.supabase.co/functions/v1/stripe-webhook`, évènement
   `checkout.session.completed` ; copier le secret de signature (étape 2).
4. Dans `mobile/.env` et les variables EAS : `EXPO_PUBLIC_STRIPE_PAYMENT_LINK=https://buy.stripe.com/…`.
   L'application ajoute elle-même `client_reference_id=<profil>`.
5. Tester avec une carte de test Stripe en mode test, puis vérifier
   `select * from preorders;`.

## 4. Le téléphone (≈ 3 h)

1. `eas init` (nouveau projet EAS : le slug `coujina-social` est neuf), puis
   `eas build --profile preview --platform android` et
   `eas build --profile development --platform ios`.
2. Installer sur **ton** téléphone ; dérouler le plan de test §1 à §9 et §14 à §18.
3. Points jamais essayés jusqu'ici : envoi de photo et de vidéo, connexion Google
   et Apple, notification push, export PDF du livre, précommande.

## 5. Le premier testeur

Avant d'inviter les 30 : créer un compte de test à toi, l'inscrire dans
`beta_testers`, lui ouvrir l'essai (`select start_trial('<id>');`), et vérifier
que `npm run beta:report` le voit.
