# Plan de test — couJina social

Chaque vérification porte un identifiant (`T-ONB-01`…). Celles marquées
**SQL** sont automatisées dans `supabase/tests/` et jouées par
`npm run db:test` ; le message d'échec cite l'identifiant. Les autres se
jouent à la main, sur téléphone, en mode démo ou sur un projet Supabase de test.

## 0. Préparer

### Les données fictives

Toutes inventées. Définies dans [`data/fictive/`](../data/fictive), lisibles
et modifiables ; `npm run seed` en tire le SQL et le mode démo du téléphone.

| Personne | @ | Cuisines | Ne mange pas | Particularité |
|---|---|---|---|---|
| Amina Benali | `amina_cuisine` | maghrébine, levantine, moyen-orientale | porc, alcool | **compte de connexion** ; a écrit le msemen (public, avec vidéo) et une harira « abonnés » |
| Lucas Martin | `lucas.bouffe` | française, méditerranéenne, ouest-européenne | — | a copié **et modifié** le msemen d'Amina |
| Priya Raman | `priya_spice` | sud-asiatique, sud-est asiatique | viande, poisson, fruits de mer | végétarienne |
| Kenji Watanabe | `kenji.ramen` | est-asiatique, sud-est asiatique | — | ramen avec vidéo |
| Fatou Diop | `fatou_dakar` | ouest-africaine, antillaise, est-africaine | porc | |
| Sofia Russo | `sofia.nonna` | méditerranéenne, ouest-européenne | gluten | **a bloqué Diego** |
| Diego Hernández | `diego_tacos` | latino-américaine, nord-américaine | arachides | jollof modifié depuis le livre |
| Léa Dubois | `lea.vegan` | 4 cuisines | viande, poisson, fruits de mer, lait, œufs | végane ; a modifié le dal de Priya |
| Omar Haddad | `omar.grill` | levantine, moyen-orientale | porc, alcool | |
| Nadia Kowalski | `nadia_patisse` | est-européenne, française | fruits à coque | **suit Marie** ; tatin aux poires (copie modifiée) |
| Tom Petit | `tom.newbie` | — | — | **compte de connexion**, jamais passé par le premier lancement |
| Marie Laurent | `marie_prive` | française, est-européenne | — | **compte de connexion** ; gratin **privé**, tatin **abonnés** |

Plus le compte éditorial `@coujina` (1 039 recettes publiques), 25
abonnements, et environ 190 copies réparties sur 30 jours — une soixantaine
dans les dernières 24 h — pour que les trois classements aient du contenu.
Relancer `npm run seed:fictive` puis recharger la base **rafraîchit les dates**.

### Trois façons de jouer

1. **SQL, sans rien installer** : `npm install && npm run seed && npm run db:test`.
2. **Mode démo** (sans serveur) : `cd mobile && npm install && npm start` ; sans
   `mobile/.env`, l'écran de connexion propose Amina, Tom et Marie. Les
   modifications sont perdues au redémarrage — c'est voulu.
3. **Projet Supabase de TEST** (jamais la production) :
   ```bash
   supabase db push
   npm run seed
   psql "$DATABASE_URL" -f supabase/seed/catalog.generated.sql
   psql "$DATABASE_URL" -f supabase/seed/fictive.generated.sql
   SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… npm run seed:accounts
   ```
   Les trois comptes et leur mot de passe sont dans
   [`data/fictive/comptes-de-test.json`](../data/fictive/comptes-de-test.json).

---

## 1. Comptes et connexion — T-AUTH (manuel, projet Supabase de test)

| ID | Scénario | Attendu |
|---|---|---|
| T-AUTH-01 | Créer un compte avec un e-mail neuf et un mot de passe de 8 caractères | Écran « Regardez vos e-mails », un code arrive |
| T-AUTH-02 | Taper le code reçu | Connecté, envoyé sur l'étape 1 du premier lancement |
| T-AUTH-03 | Taper un mauvais code | Message « Ce code a été refusé », on reste sur l'écran |
| T-AUTH-04 | Mot de passe de 7 caractères à l'inscription | Bouton désactivé |
| T-AUTH-05 | Se connecter avec `amina.test@coujina.test` | Accueil directement (déjà passée par le premier lancement) |
| T-AUTH-06 | Mauvais mot de passe | « E-mail ou mot de passe incorrect » |
| T-AUTH-07 | « Continuer avec Google » (Android, puis iOS) | Retour dans l'application, connecté ; un profil est créé avec le nom Google |
| T-AUTH-08 | « Continuer avec Apple » (iOS) | Idem ; le bouton Google n'apparaît sur iOS que si Apple est disponible |
| T-AUTH-09 | « Mot de passe oublié ? » | Message de confirmation, e-mail reçu (⚠️ l'écran du nouveau mot de passe n'existe pas encore) |
| T-AUTH-10 | Fermer et rouvrir l'application | Toujours connecté |
| T-AUTH-11 | Mode démo : choisir Amina, fermer l'onglet, revenir | Toujours Amina |

## 2. Premier lancement — T-ONB

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-ONB-01 | Se connecter comme **Tom** | Étape 1 sur 2 « Quelles cuisines aimez-vous ? », aucune cochée | SQL + démo |
| T-ONB-02 | Cocher Sud-asiatique et Méditerranéenne, Continuer, Végétarien, Valider | Accueil « Bonjour Tom », aucun plat avec viande ou poisson | SQL + démo ✅ joué |
| T-ONB-03 | Étape 1 sans rien cocher | « Continuer » désactivé, message « Choisissez au moins une cuisine » | démo |
| T-ONB-04 | Étape 2 sans rien cocher | Le bouton dit « Je mange de tout » ; les interdits sont vidés | SQL |
| T-ONB-05 | Tom essaie d'écrire dans les préférences d'Amina | Refusé par la base | SQL |
| T-ONB-06 | Fermer l'application pendant l'étape 2, rouvrir | Retour à l'étape 1 (rien n'a été enregistré à moitié) | manuel |
| T-ONB-07 | Profil → « Ce que je ne mange pas » → ajouter Gluten | Toast « Préférences enregistrées » ; l'accueil ne montre plus de gluten | démo |

## 3. Accueil — T-ACC

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-ACC-01 | Priya ouvre l'accueil | Les 10 premiers plats sont sud- ou sud-est asiatiques | SQL |
| T-ACC-02 | Priya fait défiler 50 plats | Aucun ne contient viande, poisson ou fruits de mer | SQL |
| T-ACC-03 | Chaque carte | Photo (ou dégradé de la cuisine), ▶ si vidéo, nom, nom d'origine, drapeau + pays, difficulté, temps, « Recette de … » | démo ✅ joué |
| T-ACC-04 | L'accueil d'Amina | Ni ses propres recettes, ni une recette privée de qui que ce soit | SQL |
| T-ACC-05 | Une recette du livre copiée 11 fois | Elle n'apparaît **qu'une fois** (les copies telles quelles ne s'affichent pas) | SQL |
| T-ACC-06 | Faire défiler jusqu'à la page 2 | Pas de doublon | SQL |
| T-ACC-07 | Filtre « Vidéos » | Seulement des cartes avec ▶ (msemen d'Amina, ramen de Kenji) | SQL |
| T-ACC-08 | Tirer vers le bas | Rafraîchit | manuel |
| T-ACC-09 | Couper le réseau, ouvrir l'accueil | Message d'erreur et « Réessayer », pas d'écran blanc | manuel |
| T-ACC-10 | Amina suit Omar : ses recettes remontent | Le shish taouk d'Omar est dans les premières cartes | manuel |

## 4. Tour du monde — T-GLO

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-GLO-01 | Ouvrir l'onglet | Une Terre avec une épingle par pays ayant des recettes (50 pays au catalogue) | SQL + démo ✅ joué |
| T-GLO-02 | Toucher une épingle | Elle devient orange, la Terre se recentre, le panneau montre le pays, le nombre, 4 vignettes | démo ✅ joué |
| T-GLO-03 | Amina (sans porc ni alcool) : France → Voir les recettes | Aucune recette au porc ou à l'alcool | SQL |
| T-GLO-04 | Glisser le doigt sur la Terre | Elle tourne ; les épingles restent sur leurs pays ; celles de dos disparaissent | démo ✅ joué |
| T-GLO-05 | Glisser verticalement sur la Terre | La Terre bascule, **la page ne défile pas** | manuel (téléphone) |
| T-GLO-06 | « Aller à » → Japon | Le Japon passe au centre | démo |
| T-GLO-07 | Performances : tourner la Terre en continu sur un Android d'entrée de gamme | Fluide (au moins ~30 images/s) | manuel |

## 5. Mes recettes : copier, écrire, confidentialité — T-COP, T-REC, T-CONF

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-COP-01 | Tom ouvre « Cassoulet » → Enregistrer → Publique | La copie est à Tom, « Recette de Le livre couJina », ingrédients et étapes identiques | SQL + démo ✅ joué |
| T-COP-02 | Omar ouvre « Bissara » → Copier et modifier → change le titre → Enregistrer | « Recette de Le livre couJina · modifiée par Omar Haddad » | SQL |
| T-COP-03 | Après T-COP-01 | Le compteur de copies du cassoulet a augmenté de 1 | SQL |
| T-COP-04 | Tom enregistre deux fois le cassoulet | Une seule copie, le compteur ne bouge qu'une fois | SQL |
| T-COP-05 | Omar enregistre le msemen **de Lucas** (lui-même modifié depuis Amina) | « Recette de Amina Benali · modifiée par Lucas Martin » : le crédit d'origine remonte | SQL + démo ✅ joué |
| T-COP-06 | Tom modifie plus tard une copie qu'il avait enregistrée telle quelle | Elle devient « modifiée par Tom Petit » | SQL |
| T-COP-07 | Nadia (abonnée de Marie) enregistre la tatin « Abonnés » de Marie en « Publique » | La copie reste « Abonnés » ; message « limitée à Abonnés » ; impossible de la rendre publique ensuite | SQL |
| T-COP-08 | Amina ouvre son propre msemen | Pas de bouton « Enregistrer » ; « Modifier » et « Qui peut la voir » à la place | SQL + manuel |
| T-COP-09 | Amina tente de copier le gratin privé de Marie (par son identifiant) | Refusé : recette introuvable | SQL |
| T-COP-10 | Toucher « Amina Benali » dans le crédit | Ouvre le profil d'Amina | démo |
| T-REC-01 | Mes recettes → Écrire une recette : titre, cuisine, pays, 2 ingrédients, 2 étapes, Publique | La fiche s'ouvre, « Recette de <moi> » ; elle apparaît dans l'accueil des autres | manuel |
| T-REC-02 | Ajouter une photo depuis la galerie | Vignette, puis photo sur la fiche et la carte | manuel (téléphone) |
| T-REC-03 | « Filmer les étapes » : vidéo de 30 s | Envoi, ▶ sur la carte, lecture sur la fiche | manuel (téléphone) |
| T-REC-04 | Enregistrer sans titre / sans ingrédient / sans étape | Message clair, rien n'est créé | SQL |
| T-REC-05 | Vidéo de plus de 3 minutes | Le sélecteur la coupe ou la refuse | manuel |
| T-REC-06 | Refuser l'accès à l'appareil photo | Message « couJina a besoin d'accéder… » | manuel |
| T-REC-07 | Supprimer sa recette | Confirmation, puis disparition ; les copies faites par d'autres restent | manuel |
| T-REC-08 | Filtres « Écrites par moi » / « Enregistrées » | Le bon partage ; le coin de chaque vignette dit qui la voit | démo |
| T-CONF-01 | Amina cherche le gratin **privé** de Marie | Invisible, ingrédients compris | SQL |
| T-CONF-02 | Amina (ne suit pas Marie) cherche la tatin « Abonnés » | Invisible | SQL |
| T-CONF-03 | Nadia (suit Marie) | Voit la tatin | SQL |
| T-CONF-04 | Marie rend sa tatin publique | Amina la voit | SQL |
| T-CONF-05 | Amina | Voit toutes ses propres copies, même privées | SQL |
| T-CONF-06 | Marie tente de modifier ou supprimer la recette d'Amina | Refusé | SQL |
| T-CONF-07 | Visiteur non connecté | Ne voit que du public | SQL |
| T-CONF-08 | Se connecter comme **Marie** | Son profil montre ses recettes privées avec le coin « Moi seul » | démo |

## 6. Les plus copiées — T-TOP

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-TOP-01 | Onglet Tendances : Aujourd'hui, Cette semaine, Ce mois-ci | Les trois listes sont remplies ; le jour ≤ la semaine | SQL + démo ✅ joué |
| T-TOP-02 | Lire le classement | Trié par nombre de copies, badge « #1 · 11 copies » | SQL |
| T-TOP-03 | Filtre « Maghrébine » | Uniquement maghrébin | SQL |
| T-TOP-04 | Amina, « Masquer ce que je ne mange pas » activé | Ni porc ni alcool | SQL |
| T-TOP-05 | Le désactiver | Les plats au porc / à l'alcool réapparaissent | SQL |
| T-TOP-06 | En aucun cas | Une recette que je n'ai pas le droit de voir n'apparaît | SQL |
| T-TOP-07 | Une même personne copie deux fois | Compte une fois | SQL |
| T-TOP-08 | Période inconnue envoyée à l'API | Refusée | SQL |

## 7. Profils et réseau — T-PRO, T-SOC

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-PRO-01 | Ouvrir le profil d'Omar depuis Amina | Compteurs, bio, « Vous suit », bouton « Abonné » | SQL |
| T-PRO-02 | Ouvrir le profil de Marie depuis Amina | Seules ses recettes publiques | SQL |
| T-PRO-03 | Nom d'utilisateur « A B » | Refusé ; message des règles | SQL + manuel |
| T-PRO-04 | Prendre un nom d'utilisateur déjà pris | « Ce nom d'utilisateur est déjà pris » | manuel |
| T-PRO-05 | Changer la langue en English | Toute l'interface passe en anglais ; le contenu des recettes ne change pas | démo |
| T-SOC-01 | Suivre puis ne plus suivre | Compteurs et bouton à jour | SQL + démo |
| T-SOC-02 | Après désabonnement de Marie | Ses recettes « Abonnés » disparaissent | SQL |
| T-SOC-03 | Abonner quelqu'un d'autre à sa place | Refusé | SQL |
| T-SOC-04 | Se suivre soi-même | Refusé ; son propre profil ouvre l'onglet Profil | SQL |
| T-SOC-05 | Profil → Trouver un cuisinier → « omar » | Omar Haddad | SQL + démo |
| T-SOC-06 | Sofia a bloqué Diego | Ni l'un ni l'autre ne voit les recettes de l'autre | SQL |
| T-SOC-07 | ••• → Signaler → « Spam » | « Merci — notre équipe va regarder » ; une ligne dans `reports` | manuel |

## 8. Interdits alimentaires — T-REG

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-REG-01 | « 200 g de lardons fumés », « 1 poulet fermier », « 3 carottes » | porc + viande ; viande ; rien | SQL |
| T-REG-02 | Recette avec lardons et crème, auteur déclare « gluten » | Drapeaux porc, viande, lait, gluten | SQL |
| T-REG-03 | Noix en ingrédient **facultatif** | Ne cache pas le plat | SQL |
| T-REG-04 | Fiche d'un plat avec drapeaux | Bandeau « Contient : … » | démo ✅ joué |

## 9. Compte — T-CPT

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-CPT-01 | Profil → Supprimer mon compte | Confirmation explicite, puis déconnexion | manuel |
| T-CPT-02 | Après suppression de Léa | Profil, recettes, abonnements effacés | SQL |
| T-CPT-03 | Une copie faite par Priya d'une recette de Léa | Reste à Priya ; le crédit devient vide, plus de lien cassé | SQL |

## 10. Avant une publication sur les magasins (manuel)

| ID | Vérification |
|---|---|
| T-STO-01 | iPhone réel + Android réel : tout le §1 à §9 |
| T-STO-02 | Petit écran (iPhone SE), grand écran, texte agrandi par l'accessibilité |
| T-STO-03 | Lecteur d'écran (VoiceOver / TalkBack) sur l'accueil, la fiche, le globe |
| T-STO-04 | 4G faible : envoi d'une vidéo de 2 min, interruption, reprise |
| T-STO-05 | Mode avion : aucun plantage, messages lisibles |
| T-STO-06 | Les crédits des images Wikimedia sont affichés (voir ETAT.md §4) |

## 11. Crédit des photos — T-IMG (14/11/2026)

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-IMG-01 | Toutes les recettes du livre qui ont une photo | Chacune a son crédit (auteur, licence, « via Wikimedia Commons ») | SQL |
| T-IMG-02 | Le berbéré (photo d'origine : une carte des langues berbères) | Plus de photo, le dégradé de la cuisine à la place | SQL |
| T-IMG-03 | Enregistrer une recette du livre qui a une photo | La copie garde la photo et son crédit | SQL |
| T-IMG-04 | Dans sa copie, remplacer la photo par la sienne | Le crédit Wikimedia disparaît | SQL |
| T-IMG-05 | Ouvrir « Bissara » | Sous la photo : « Photo : EKez — CC BY-SA 3.0, via Wikimedia Commons » ; le toucher ouvre la page Commons | démo ✅ joué |

## 12. Mesure de la bêta — T-MES

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-MES-01 | `beta_metrics()` sur les données fictives | 11 testeurs, J+1 et J+7 calculés, réponses au prix par prix | SQL |
| T-MES-02 | Ouvrir l'app deux fois en une minute | Une seule visite comptée | SQL |
| T-MES-03 | Profil → décocher « Aider à améliorer couJina », puis ouvrir des recettes | Rien n'est enregistré | SQL + manuel |
| T-MES-04 | Après 3 jours d'usage, l'accueil | Carte « Une question rapide » avec un prix (2,99, 3,99 ou 4,99 €) ; répondre la fait disparaître pour toujours | SQL + démo ✅ joué |
| T-MES-05 | Un utilisateur tente de lire `app_events` ou `beta_metrics()` | Refusé | SQL |
| T-MES-06 | `DATABASE_URL=… npm run beta:report` sur le projet de test | Le tableau des chiffres s'affiche | manuel |

## 13. Réseau encore vide — T-VIDE

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-VIDE-01 | Accueil | Bandeau « Défi de la semaine », un seul défi, qui change le lundi | SQL + démo ✅ joué |
| T-VIDE-02 | Toucher le bandeau | Le thème et les participations, sans ce que je ne mange pas | SQL + démo ✅ joué |
| T-VIDE-03 | Écrire une recette avec « Participer au défi » coché, publique | Elle apparaît dans le défi ; impossible d'inscrire la recette d'un autre ; une recette « Moi seul » n'est pas inscrite | SQL + manuel |
| T-VIDE-04 | Accueil → « Des cuisiniers à suivre » | Ceux qui partagent mes cuisines d'abord ; jamais quelqu'un que je suis déjà ou que j'ai bloqué ; « Suivre » le retire de la liste | SQL + démo |
| T-VIDE-05 | Profil → Activité (Amina) | « Lucas Martin a fait sa version de Msemen de ma mère », nouveaux abonnés | SQL + démo ✅ joué |
| T-VIDE-06 | Revenir au profil après l'Activité | Le compteur de nouveautés est à zéro | SQL |
| T-VIDE-07 | Profil → Inviter des amis | La feuille de partage du téléphone, avec le lien `coujinasocial://u/<nom>` ; ce lien ouvre mon profil chez qui a l'app | manuel |

## 14. Conformité — T-LEG (15/11/2026)

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-LEG-01 | Premier lancement d'un compte neuf | Écran « Avant de commencer » ; rien de coché ; liens vers les CGU et la politique de confidentialité, lisibles avant d'accepter | SQL + démo ✅ joué |
| T-LEG-02 | Ne pas cocher « J'ai 15 ans ou plus » | « Continuer » reste désactivé ; la base refuse `accept_terms` sans les 15 ans | SQL + démo ✅ joué |
| T-LEG-03 | Étape « ce que je ne mange pas » sans accord | Panneau d'explication, « J'accepte » et « Passer » ; la base refuse tout interdit sans accord | SQL + démo ✅ joué |
| T-LEG-04 | Profil → « Retirer mon accord » | Confirmation, puis interdits effacés et accord retiré | SQL + manuel |
| T-LEG-05 | La version des CGU change (`current_terms_version()`) | Tous les comptes repassent par « Avant de commencer » | manuel |
| T-LEG-06 | Fiche d'une recette | Avertissement allergènes permanent ; sur une copie modifiée, bandeau « X a modifié les ingrédients de la recette de Y » | démo |

## 15. Modération — T-MOD

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-MOD-01 | Un utilisateur ordinaire | Ne lit pas la file, ne se nomme pas modérateur | SQL |
| T-MOD-02 | Signaler « Un allergène n'est pas indiqué » | Le signalement arrive dans la file de modération | SQL |
| T-MOD-03 | Masquer sans motif | Refusé ; avec motif : la recette disparaît, ses signalements sont clos | SQL + démo |
| T-MOD-04 | Recette masquée | Invisible dans l'accueil, le globe, les classements ; son auteur la voit, avec le motif | SQL |
| T-MOD-05 | Feuille d'opérations | Reçus, traités, sous 24 h, encore ouverts, par semaine | SQL + démo ✅ joué |
| T-MOD-06 | L'auteur tente de lever le masquage | Refusé | SQL |
| T-MOD-07 | Copier une recette masquée | Refusé | SQL |

## 16. Livre de famille (premium) — T-FAM

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-FAM-01 | Nadia (membre de « Famille Laurent ») | Lit le gratin « Moi seul » de Marie rangé dans le livre ; Amina (hors livre) ne le lit pas | SQL |
| T-FAM-02 | Code d'invitation | Montré à la créatrice seulement | SQL + démo ✅ joué |
| T-FAM-03 | Créer un livre sans abonnement | Refusé, avec le message Premium | SQL |
| T-FAM-04 | Rejoindre avec « LAURENT1 » | Membre ; les recettes du livre deviennent lisibles | SQL |
| T-FAM-05 | Ranger la recette d'un autre | Refusé (on l'enregistre d'abord) | SQL |
| T-FAM-06 | Quitter le livre | Ses recettes privées redeviennent invisibles | SQL |
| T-FAM-07 | Abonnement échu | Livre lisible, plus d'ajout | SQL |
| T-FAM-08 | « Exporter le livre (PDF) » | Une page par recette : titre, crédit « Recette de X · modifiée par Y », mot de la famille, photo et son crédit, ingrédients, étapes | démo ✅ joué (contenu vérifié) ; PDF sur téléphone : manuel |

## 17. Notifications — T-NOT

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-NOT-01 | Enregistrer un jeton invalide | Refusé | SQL |
| T-NOT-02 | Deux copies et un abonné dans la journée | Une seule notification : « X et 1 autre ont enregistré vos recettes · Y vous suit » | SQL |
| T-NOT-03 | Entre 21 h et 9 h | Rien n'est envoyé | SQL |
| T-NOT-04 | Nouvel évènement le même après-midi | Attend le lendemain | SQL |
| T-NOT-05 | Couper « Quelqu'un enregistre mes recettes » | Plus de notification de copie | SQL |
| T-NOT-06 | Un utilisateur tente de vider la file | Refusé | SQL |
| T-NOT-07 | Première recette enregistrée sur un vrai téléphone | La permission est demandée à ce moment-là (pas avant) ; la notification touchée ouvre l'Activité | manuel (téléphone + projet EAS) |

## 18. Argent réel et sécurité allergènes — T-PAY, T-ALL (3e passage)

| ID | Scénario | Attendu | Auto |
|---|---|---|---|
| T-PAY-01 | Stripe confirme une précommande (webhook) | Une ligne dans `preorders`, un an de Premium | SQL |
| T-PAY-02 | Stripe renvoie le même évènement | Compté une seule fois | SQL |
| T-PAY-03 | Essai de 30 jours ouvert par l'équipe | Premium pendant l'essai ; créer un livre possible | SQL |
| T-PAY-04 | Un utilisateur tente de s'offrir l'essai ou le paiement | Refusé | SQL |
| T-PAY-05 | `npm run beta:report` | Section « Argent réel » : livres créés, exports, payé, payé après un export, délai jusqu'à la 1re recette, qui saisit | SQL |
| T-PAY-06 | Signature Stripe : valide, corps modifié, mauvais secret, rejeu d'une heure, en-tête absent | Seule la valide passe | `deno task test` |
| T-PAY-07 | Profil → Premium → « Précommander ma première année — 29 € » | Ouvre le lien Stripe avec le profil ; au retour, « Merci ! Premium jusqu'au … » | démo (paiement simulé) ; réel : manuel avec une carte de test Stripe |
| T-ALL-01 | Signaler « Un allergène n'est pas indiqué » | La recette disparaît aussitôt pour tous ; l'autrice voit « Masquée par précaution » | SQL |
| T-ALL-02 | Le modérateur classe le signalement | La recette réapparaît | SQL |
| T-ALL-03 | Plus de 5 signalements « allergène » en 24 h par la même personne | Plus de masquage automatique pour elle | SQL |
