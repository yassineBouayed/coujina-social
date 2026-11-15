# Bêta à 20 cuisiniers — protocole

La bêta répond à ce que les cinq requins ont demandé avant de reparler
d'investissement : des **vrais cuisiniers**, sur de **vrais téléphones**, pendant
**un mois**, et quatre chiffres — combien publient, combien suivent, combien
reviennent, combien paieraient. Elle remplace aussi les estimations du
[modèle économique](modele-economique.xlsx) par des mesures.

## Qui

> Mis à jour le 15/11/2026 après le 2e passage du panel : **France et Belgique**,
> diaspora francophone, recrutés par une annonce de 200 € et un formulaire de
> sélection — détail dans [recrutement-beta.md](recrutement-beta.md). Bêta du
> **13/01 au 10/02/2027**, décision le **31/03/2027** ([engagement.md](engagement.md)).
> Mis à jour après le 3e passage : 30 jours d'essai du livre de famille, puis
> une **précommande payée** (29 €, un an, lien Stripe). On ne compte plus des
> « oui », on compte des paiements.

- **20 personnes** qui cuisinent au moins trois fois par semaine et publient déjà
  (Instagram, TikTok, groupe familial, blog) — c'est d'elles que dépend un
  réseau vide.
- Mélanger les cuisines : au moins 5 cuisines différentes parmi les 16.
- **Aucun proche du fondateur** : leurs réponses ne valent rien sur le prix
  (le formulaire de sélection les écarte).
- Recrutement : l'annonce payée et son formulaire ([recrutement-beta.md](recrutement-beta.md)).
  Noter d'où vient chacun (colonne `note` de `beta_testers`).

## Avant le jour 1

1. Projet Supabase **de test** monté (README, « Sur un projet Supabase »), le livre
   chargé (`catalog.generated.sql`) — **pas** les données fictives.
2. Build interne : `eas build --profile preview` (APK Android) et TestFlight pour
   iPhone. Vérifier le plan de test §1 à §9 sur un iPhone et un Android réels.
3. Chaque testeur crée son compte lui-même, puis on l'inscrit dans la cohorte :
   ```sql
   insert into beta_testers (profile_id, note)
   select id, 'marché de Belleville' from profiles where username = '…';
   ```
4. Leur expliquer la mesure (visites comptées, rien d'autre, désactivable dans
   le profil) et leur donner un contact pour les problèmes.

## Pendant le mois

| Semaine | Ce qui se passe | Ce qu'on fait |
|---|---|---|
| 1 | Installation, premier lancement, premières copies | Un message à J+2 à ceux qui ne sont pas revenus ; noter les blocages |
| 2 | Premier défi de la semaine ; la question du prix apparaît après 3 jours d'usage | `npm run beta:report` chaque lundi |
| 3 | Invitations : chacun invite 2 personnes (bouton « Inviter des amis ») | Compter les invités qui s'installent |
| 4 | Entretiens de 15 minutes avec 8 testeurs : qu'avez-vous supprimé pour faire de la place ? qu'est-ce qui vous ferait payer ? | Rapport final |

Ne rien ajouter au produit pendant le mois, sauf une panne : sinon on mesure
deux applications différentes.

## Les chiffres, et ce qu'ils décident

`DATABASE_URL=… npm run beta:report` les sort tous :

| Chiffre | Demandé par | Seuil « on continue » | Si on est en dessous |
|---|---|---|---|
| Ont publié une recette | Customer, Skeptic | ≥ 8 sur 20 | Le réseau restera vide : renforcer défis et recettes du livre à refaire |
| Suivent quelqu'un | Customer | ≥ 12 sur 20 | Mieux mettre en avant « Des cuisiniers à suivre » |
| Revenus le lendemain (J+1) | Skeptic | ≥ 40 % | Le problème est le produit, pas l'acquisition : ne rien dépenser en publicité |
| Revenus la semaine suivante (J+7) | Skeptic | ≥ 25 % | Idem |
| Familles qui ont **payé** la précommande | Tech Billionaire, Customer | ≥ 5 familles hors entourage, dont au moins une après avoir exporté son livre | Abandonner l'abonnement comme premier modèle ; regarder les marques |
| « Oui » à la question du prix (19 / 29 / 39 € par an) | — | indicatif : dit où le prix bascule | — |
| Signalements | — | < 1 par testeur | Outil de modération avant toute ouverture publique |

Les seuils sont des **propositions** pour décider vite, pas des normes du
secteur : les ajuster avant le jour 1, pas après avoir vu les chiffres.

## Ce que la bêta ne prouvera pas

- Qu'un inconnu, sans le fondateur pour l'accompagner, comprend l'application.
- Le vrai coût d'acquisition : il faut pour cela un petit test payant (100 à
  200 € de publicité ciblée, voir l'onglet « À mesurer en bêta » du modèle).
- Qu'un « oui » à la question du prix devient un paiement : seul un vrai bouton
  d'abonnement le dira.
