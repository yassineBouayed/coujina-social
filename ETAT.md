# couJina social — état du projet

> Mis à jour le 15/11/2026 : points soulevés par le panel /shark, 1er (§5), 2e (§6) et 3e passage (§7). Nouveau projet, né de l'ancien « application pour
> famille » (couJina, gestion de foyer) : l'idée a changé, on garde ce qui sert
> un **réseau social de cuisine grand public** et on laisse le reste.

**Légende** — ✅ fait et vérifié · 🟡 écrit mais pas vérifié en conditions réelles · ❌ pas fait

**Ce qui a été vérifié, et comment**

| Vérification | Résultat |
|---|---|
| `npm run db:test` — 11 migrations, 2 amorçages joués deux fois (idempotence), 14 fichiers de tests SQL ; `deno task test` (signature Stripe) | ✅ tout passe |
| `npm run typecheck` (TypeScript strict) dans `mobile/` | ✅ aucune erreur |
| Application web en **mode démo** (sans Supabase), taille téléphone : connexion démo → cuisines → interdits → accueil → fiche → « Enregistrer » → globe (toucher, faire tourner) → tendances → attribution « modifiée par » | ✅ parcours joué dans le navigateur |
| Projet Supabase réel, connexion Google / Apple / e-mail, envoi de photos et de vidéos, iPhone et Android | ❌ **jamais joué** : aucun projet Supabase n'existe encore pour ce produit |

---

## 1. Ce qui a été repris de l'ancien projet

| Repris | D'où | Ce qui a changé |
|---|---|---|
| **Le livre : 1 039 recettes**, 16 cuisines, 50 pays, 5 continents | `data/recipes/**`, `data/*.psv` | Les pays ont reçu des coordonnées (lat/lng) pour le globe. Les recettes deviennent des publications du compte éditorial `@coujina`, en français. |
| Le référentiel d'ingrédients et ses synonymes, et le **rattachement automatique** | `data/ingredients.psv`, `tools/probe/`, `tools/refdata/` | Sert désormais à calculer les **drapeaux alimentaires** de chaque recette. Nouveau drapeau `meat` (viande), déduit des catégories viandes / volailles / charcuterie : il rend possible « végétarien ». |
| 1 008 **images candidates** Wikimedia | `plats-images.txt` | Licence et auteur vérifiés auprès de Commons (`npm run images:credits`) : 774 affichées avec leur crédit, 230 masquées en attente de relecture, 3 retirées. Voir §5. |
| La **charte** : couleurs, polices, logo J-louche, icônes, planches | `mobile/src/theme.ts`, `ui/Logo.tsx`, `assets/`, `design/` | Inchangée. Le nom couJina est gardé. |
| Les composants d'interface (Screen, Card, Chip, Toggle, boutons, champ texte, toast) | `mobile/src/ui/` | Retrait des contrôles propres au stock. |
| Le **français / anglais** (catalogue typé : une clé non traduite ne compile pas) | `mobile/src/i18n/` | Nouveau catalogue de messages. |
| La **connexion Google et Apple**, le retour par lien profond, PKCE | `mobile/src/auth.tsx` | Le lien magique est remplacé par **e-mail + mot de passe** (+ code de confirmation). Ajout du **mode démo**. |
| Le client Supabase | `mobile/src/supabase.ts` | Simplifié. |
| L'**outillage de test SQL** sans Docker (PostgreSQL embarqué) | `tools/db.mjs` | Repris tel quel. |
| L'idée de l'**onboarding** (cuisines, puis régimes, en un seul appel) | ancien `app/index.tsx`, `taste.tsx` | Préférences **personnelles** (plus de foyer). |

**Laissé dans l'ancien projet** (sans objet pour un réseau social) : le foyer et ses membres, le stock, la liste de courses partagée, la session de courses, le lien de courses, les suggestions « cuisinable ce soir », le journal des repas, le mode hors ligne, le QR code, les notifications push, l'export RGPD (à refaire, §4).

---

## 2. Les fonctionnalités demandées

### Comptes et connexion

| | État | Détail |
|---|---|---|
| Inscription e-mail + mot de passe | 🟡 | `signUp` puis code à 6 chiffres envoyé par e-mail. Le modèle d'e-mail Supabase doit contenir `{{ .Token }}`. |
| Connexion e-mail + mot de passe | 🟡 | |
| Connexion Google | 🟡 | Code repris de l'ancien projet, qui fonctionnait. À brancher sur le nouveau projet Supabase. |
| Connexion Apple (iOS) | 🟡 | **Ajoutée** : l'App Store l'exige dès qu'on propose Google (règle 4.8). |
| Mot de passe oublié | 🟡 / ❌ | L'e-mail part ; **l'écran « choisir un nouveau mot de passe » au retour du lien n'existe pas**. |
| Profil créé automatiquement, nom d'utilisateur unique | ✅ | Déclencheur SQL ; nom tiré de l'e-mail ou du nom Google. |
| Mode démo sans serveur (3 comptes fictifs) | ✅ | Quand `mobile/.env` est absent. |

### Premier lancement

| | État | Détail |
|---|---|---|
| Étape 1 : cuisines préférées | ✅ | 16 cuisines. |
| Étape 2 : ce que l'on ne mange pas | ✅ | 10 interdits + raccourcis Végétarien / Végane / Sans porc ni alcool. |
| Les deux réponses enregistrées en un seul appel | ✅ | `profile_onboard()`. Testé (T-ONB). |
| Modifiables ensuite depuis le profil | ✅ | Mêmes écrans, `?edit=1`. |

### 1. Accueil

| | État | Détail |
|---|---|---|
| Recettes et vidéos selon les cuisines aimées | ✅ | Classement : cuisine aimée +3, auteur suivi +2, popularité, fraîcheur. |
| Jamais ce que l'on ne mange pas | ✅ | Testé sur Priya (végétarienne) — T-ACC-02. |
| Cartes : photo ou vidéo, nom, origine, difficulté, temps | ✅ | + nom d'origine et crédit cliquable. |
| Filtre Tout / Recettes / Vidéos, défilement infini, tirer pour rafraîchir | ✅ | |
| Lecture automatique des vidéos dans le fil | ❌ | La carte montre ▶ ; la vidéo se lit sur la fiche. |

### 2. Tour du monde

| | État | Détail |
|---|---|---|
| Globe terrestre navigable au doigt | ✅ | SVG (d3-geo + Natural Earth), sans clé de carte, marche dans Expo Go et sur le web. |
| Épingles par pays, taille selon le nombre de recettes | ✅ | Respecte les interdits. |
| Toucher une épingle → recentrer, aperçu, « Voir les recettes » | ✅ | |
| Raccourcis « Aller à » par pays | ✅ | |
| Zoom à deux doigts, rotation avec inertie, régions sous le pays | ❌ | |

### 3. Mes recettes

| | État | Détail |
|---|---|---|
| « Enregistrer » une recette telle quelle | ✅ | `copy_recipe()`. Une seconde fois ne la double pas. |
| « Copier et modifier » | ✅ | `recipe_save(…, copied_from)`. |
| Crédit : « Recette de X » ou « Recette de X · modifiée par Y » | ✅ | Le créateur d'origine remonte toute la chaîne (T-COP-05). |
| Les noms mènent au profil | ✅ | |
| Écrire sa propre recette | ✅ | Titre, nom d'origine, cuisine, pays, difficulté, temps, personnes, ingrédients (facultatifs), étapes, interdits déclarés. |
| Choisir la confidentialité : Publique / Abonnés / Moi seul | ✅ | À la copie, à l'écriture, et après coup. |
| Suivre / être suivi | ✅ | |
| **Filmer** une vidéo des étapes, ou l'importer | 🟡 | Appareil photo ou galerie, 3 min max, envoi vers Supabase Storage. Jamais essayé sur téléphone. |
| Ajouter une photo | 🟡 | Une photo de couverture. **Plusieurs photos, photo par étape : ❌.** |
| Vidéo **téléchargeable avec le « markdown » de l'application** | ❌ | Compris comme un **filigrane** (le logo couJina incrusté) — à confirmer. Demande un traitement serveur (ffmpeg dans une fonction) ; rien n'est fait. |
| Vidéo rattachée à une étape précise | ❌ | La table `recipe_media.step_position` est prête, l'écran non. |

### 4. Les plus copiées

| | État | Détail |
|---|---|---|
| Du jour, de la semaine, du mois | ✅ | Fenêtres glissantes 24 h / 7 j / 30 j. |
| Toutes les spécialités, filtre par cuisine | ✅ | |
| Option « masquer ce que je ne mange pas » | ✅ | Activée par défaut. |
| Une personne ne compte qu'une fois par recette | ✅ | Contre le gonflage du classement (T-TOP-07). |

### 5. Mon profil

| | État | Détail |
|---|---|---|
| Compteurs recettes / abonnés / abonnements | ✅ | |
| Modifier nom, nom d'utilisateur, bio | ✅ | |
| Préférences (cuisines, interdits), langue | ✅ | |
| Déconnexion, suppression du compte | ✅ | La suppression est testée table par table (T-CPT). |
| Photo de profil | ❌ | Colonne `avatar_url` prête ; pas d'écran. |
| Changer d'e-mail ou de mot de passe | ❌ | |
| Rechercher quelqu'un à suivre | ✅ | Par nom ou @nom. |
| Bloquer, signaler | ✅ | Exigé par l'App Store (règle 1.2) pour tout contenu publié par les utilisateurs. |
| Listes « abonnés » / « abonnements » consultables | ❌ | Seuls les nombres s'affichent. |

---

## 3. Décisions prises en chemin — à valider

1. **Une copie n'est jamais plus ouverte que l'original.** Une recette « Abonnés » copiée ne peut pas devenir publique chez celui qui la copie ; sinon, la confidentialité de l'auteur ne vaudrait rien. Vous avez écrit que l'on choisit la confidentialité « quelle que soit » l'origine : c'est vrai **dans cette limite**.
2. **Par défaut, une copie est « Moi seul ».** L'écran demande à chaque fois.
3. **L'accueil et le globe ne montrent pas les copies telles quelles** (sinon une recette populaire apparaîtrait vingt fois). Ils montrent les originaux et les versions modifiées. Les copies restent sur le profil de chacun.
4. **Les copies modifiées comptent** dans « les plus copiées ».
5. **Détection des interdits volontairement prudente** : « lait de coco » cache le plat pour qui exclut le lait. Mieux vaut cacher un plat de trop qu'un de moins en cas d'allergie ; l'avertissement est affiché.
6. **Sans porc ni alcool, pas « halal »** : l'application ne sait rien de l'abattage, elle ne le prétend pas.
7. **« markdown » compris comme « filigrane »** (voir §2).
8. **Le nom couJina est gardé**, avec sa charte.

---

## 4. Ce qui manque pour une mise en production grand public

**Bloquant avant toute publication**

- ❌ **Projet Supabase** de test puis de production : `supabase db push`, amorçage, fournisseurs Google / Apple / e-mail, modèles d'e-mail, URL de retour `coujinasocial://auth-callback`.
- ❌ **Nouveau projet EAS** (le slug a changé : `coujina-social`) et identifiants `app.coujina.social`.
- 🟡 **Images Wikimedia** : licences vérifiées et crédit affiché (§5). Reste la **relecture humaine** : `data/images/a-revoir.csv` liste 301 photos (230 masquées, 68 affichées mais incertaines, 3 retirées pour licence). Une photo jugée bonne s'ajoute à `data/images/valide.txt`. Même « sûre », une photo peut montrer un plat voisin (« Gratin de christophine » illustré par un gratin dauphinois).
- ❌ **Médias privés** : le bucket est public. L'adresse d'une photo d'une recette « Moi seul » est lisible par qui la connaît. Passer aux URL signées.
- ❌ **Conditions d'utilisation, politique de confidentialité, âge minimum** (15 ans en France sans accord parental), page de contact.
- ❌ **Modération** : les signalements sont enregistrés, mais personne ne les lit — il faut un outil d'administration, et un filtrage automatique des textes et des images.
- ❌ **Export des données personnelles** (RGPD, droit d'accès) — la suppression, elle, existe.
- ❌ Essais sur **vrais téléphones** iOS et Android, en particulier caméra, envoi de vidéo et connexion Google / Apple.

**Important, juste après**

- ❌ Vidéo : compression, miniature, envoi reprenable (le fichier est aujourd'hui lu entier en mémoire), quotas, nettoyage du stockage quand une recette est supprimée. Les copies pointent vers les fichiers de l'original : s'il les supprime, l'image disparaît chez les copieurs.
- ❌ Recherche de recettes par mot (seule la recherche de personnes existe).
- 🟡 Notifications : la page Activité existe (§5) ; les **notifications push**, non.
- ❌ Protection contre les abus : limite de débit, comptes multiples pour gonfler les classements.
- ❌ Suivi des plantages et des performances (Sentry ou équivalent), analytique respectueuse du consentement.
- ❌ Intégration continue : `db:test` et `typecheck` à chaque commit.
- ❌ Accessibilité relue, vraies icônes à la place des glyphes de la barre d'onglets.
- ❌ Contenu en anglais : le livre est en français seulement (l'ancien projet avait les deux langues ; le nouveau schéma ne garde qu'une langue par recette).
- ❌ Montée en charge : l'accueil et les classements sont calculés à la demande ; au-delà de quelques dizaines de milliers de recettes, il faudra des vues matérialisées.
- ❌ Fiches App Store / Google Play à réécrire pour le nouveau produit.

---

## 5. Les points soulevés par le panel /shark (14/11/2026)

Les cinq investisseurs fictifs de `/shark` ont dit non, pour des raisons qui
se rangent en trois familles. Ce qui relève du code est fait ; ce qui relève
d'une décision reste au fondateur.

| Point soulevé | Par | Ce qui a été fait | Reste à faire |
|---|---|---|---|
| Photos dont on ne sait pas si on a le droit | Royalty | ✅ Licence et auteur demandés à Commons pour les 1 008 photos ; crédit stocké en base et affiché sous chaque photo (lien vers la page Commons) ; un crédit suit la photo dans les copies et tombe si l'auteur la change ; licences NC/ND/GFDL seule refusées ; photos sans lien avec le plat masquées (carte des langues berbères pour le berbéré, halo-halo pour le flan coco, une photo pour 5 plats). Test T-IMG. | Relire `data/images/a-revoir.csv` (301 photos) |
| Aucun chiffre : qui paie, combien, coût par utilisateur, coût d'acquisition | Numbers, Tech Billionaire, Royalty | ✅ [docs/modele-economique.xlsx](docs/modele-economique.xlsx) : trois modèles (abonnement, publicité, recettes sponsorisées) × trois tailles, coûts et revenus sourcés, hypothèses modifiables, remboursement d'un utilisateur acquis. | **Choisir le modèle** — après la bêta |
| Personne n'a essayé : publient-ils, suivent-ils, reviennent-ils, paieraient-ils ? | Customer, Skeptic | ✅ Mesure des visites (désactivable), question du prix à 2,99 / 3,99 / 4,99 € posée après 3 jours d'usage, cohorte `beta_testers`, `npm run beta:report` (publient, suivent, J+1, J+7, oui au prix). Protocole : [docs/beta-20-cuisiniers.md](docs/beta-20-cuisiniers.md). Test T-MES. | **Recruter les 20 cuisiniers** et faire la bêta |
| Un réseau vide le premier mois | Skeptic, Customer | ✅ Défi de la semaine (12 thèmes qui tournent tout seuls, inscription depuis l'éditeur), « Des cuisiniers à suivre » sur l'accueil, page Activité (« X a copié votre recette »), bouton « Inviter des amis » et lien `coujinasocial://u/<nom>`. Test T-VIDE. | Notifications push ; lien d'invitation web (le lien actuel n'ouvre que l'app déjà installée) |
| « Avez-vous déjà abandonné un projet ? » | Tech Billionaire, Skeptic | — | Décision du fondateur : temps, budget, échéance qu'il s'engage à tenir |

**Ce que le modèle économique dit, avec ses hypothèses actuelles** : à 10 000
utilisateurs actifs, l'abonnement couvre à peine les coûts (+8 €/mois), la
publicité dégage le plus (+1 815 €/mois, mais sur un revenu publicitaire mal
sourcé), et **aucun modèle ne rembourse rapidement un utilisateur acquis par
publicité payante** (46 mois au mieux). La croissance devra venir du
bouche-à-oreille — défis et invitations — et c'est ce que la bêta doit mesurer
avant toute dépense.

---

## 6. Le 2e passage du panel /shark (15/11/2026)

Cinq « non » au deuxième passage, cette fois sur la conformité, les opérations,
le marché et l'engagement. Les décisions ont été prises une à une (séance de
questions du 15/11) ; voici ce qui en est fait.

| Point soulevé | Par | Décision | Fait | Reste |
|---|---|---|---|---|
| Choix alimentaires = données sensibles (RGPD art. 9), sans consentement | Legal | Consentement explicite, daté, retirable ; hébergement UE | ✅ Écran d'explication avant la question, « Passer » possible ; la base **refuse** tout interdit sans accord ; retrait dans le profil = effacement. Test T-LEG. | Choisir la région UE du projet Supabase |
| Pas de CGU, pas de politique de confidentialité, âge | Legal | 15 ans, déclaratif ; couJina hébergeur | ✅ Premiers jets dans [docs/legal/](docs/legal), embarqués dans l'app ; écran « Avant de commencer » (rien de pré-coché) ; la base refuse sans les 15 ans ; nouvelle version des CGU = nouvelle acceptation. | **Relecture par un juriste** (≈ 600 €), compléter les [À COMPLÉTER] |
| Responsabilité des allergènes sur les copies modifiées | Legal | Hébergeur + avertissements | ✅ Avertissement permanent sur chaque fiche ; bandeau sur les copies modifiées ; motif de signalement « allergène manquant » ; CGU art. 4. | Validation juriste |
| Pas d'outil de modération (Apple, DSA) | Legal, Operator | Fondateur seul, 2 h/semaine, 24 h | ✅ Rôle modérateur (posé en SQL), file des signalements, masquage **motivé** que l'auteur lit (DSA art. 17), une recette masquée disparaît partout et ne se copie plus, feuille d'opérations (`ops_weekly`). Test T-MOD. | Contestation : par e-mail pour l'instant |
| Qui fait le travail chaque semaine ? | Operator | Le fondateur, 2 h | ✅ [docs/operations-hebdo.md](docs/operations-hebdo.md) : tâches, temps, feuille à remplir | La remplir pendant la bêta |
| Rien derrière le prix | Customer | Le livre de famille | ✅ Cercle privé (un abonnement par famille, rejoindre gratuit, 30 personnes), les recettes « Moi seul » rangées visibles des membres seulement, export en livre PDF (crédits compris). La question du prix le nomme. Test T-FAM. | Achat dans les magasins (RevenueCat) ; pendant la bêta, Premium offert à la main |
| Rien ne fait revenir le 2e jour | Customer | Notifications push sobres | ✅ Trois cas, une par 20 h, regroupée, rien entre 21 h et 9 h, réglables ; permission demandée après la 1re recette enregistrée ; fonction d'envoi `push-dispatch`. Test T-NOT. | Projet EAS (le jeton Expo en a besoin), planifier l'envoi (supabase/functions/README.md), essai sur téléphone |
| Concurrents, pays, public | Market | Diaspora francophone ; France + Belgique d'abord | ✅ [docs/concurrents.md](docs/concurrents.md) — **à retenir** : des apps de livre de famille existent déjà ; l'angle de couJina est la combinaison réseau + généalogie des recettes + diaspora francophone | Vérifier les fiches concurrentes dans les apps |
| Pourquoi maintenant, quel rempart | Market | La communauté et les livres de famille remplis | ✅ Question dédiée dans le formulaire de recrutement | La mesurer |
| Où trouver 20 cuisiniers, quand | Operator, Customer | Annonce 200 € + formulaire, 30 invités | ✅ [docs/recrutement-beta.md](docs/recrutement-beta.md) : ciblage, formulaire, calendrier (bêta 13/01 → 10/02/2027) | Lancer l'annonce le 01/12/2026 |
| Un seul payeur, une preuve d'argent | Tech Billionaire | Abonnement premium ; 5 messages à des marques en parallèle | ✅ [docs/messages-marques.md](docs/messages-marques.md) | Choisir les 5 marques, envoyer |
| « Business ou hobby ? » | Tech Billionaire | 10 h/semaine, 1 500 €, décision au 31/03/2027 | ✅ [docs/engagement.md](docs/engagement.md) : budget détaillé, règle de décision | La tenir |

**Vérifié** : 13 fichiers de tests SQL, typage, et dans le navigateur (mode
démo) : le parcours de Tom (CGU → cuisines → accord → interdits → accueil), le
livre de Marie et son export (contenu des 3 pages vérifié), la file de
modération d'Amina. **Pas vérifié** : l'impression PDF et les notifications sur
un vrai téléphone, l'envoi réel par Expo.

**Corrigé en chemin** : sur le web, `expo-print` ignore le HTML et imprime la
page en cours ; l'export ouvre désormais le livre dans sa propre fenêtre.

---

## 7. Le 3e passage du panel /shark (15/11/2026)

Cinq « non », tous sur la même chose : **pas encore d'argent réel, pas encore de
vrai téléphone, pas encore d'avis de juriste**. Ce qui relève du code et des
chiffres est fait ; le reste est planifié, semaine par semaine.

| Point soulevé | Par | Décision | Fait | Reste |
|---|---|---|---|---|
| « Je paie chaque mois un livre que j'imprime une fois » | Customer | **Abonnement annuel, 29 € par famille** | ✅ Prix, offre et question du prix (19 / 29 / 39 € par an) à l'année | — |
| Un « oui » gratuit ne prouve rien | Customer, Tech Billionaire | **Essai 30 jours, puis précommande payée** (lien Stripe) | ✅ Écran Premium, essai, table `preorders`, fonction `stripe-webhook` (signature vérifiée, idempotente), rapport « Argent réel » (payé, payé après export) ; seuil de la bêta : **5 familles hors entourage qui ont payé**. Test T-PAY. | Compte Stripe, lien de paiement, webhook ([mise-en-production.md](docs/mise-en-production.md)) |
| Qui saisit les recettes, en combien de temps | Customer | Le mesurer | ✅ Rapport : délai création du livre → 1re recette, recettes rangées par le créateur / par la famille | Les mesurer en bêta |
| Le premier arachide manqué | Legal | **Masquage immédiat** au signalement | ✅ Une recette signalée « allergène manquant » disparaît aussitôt, jusqu'à vérification ; plafond anti-abus. Test T-ALL. | — |
| Avis écrit d'un juriste | Legal | — | ✅ [docs/legal/questions-juriste.md](docs/legal/questions-juriste.md) : les questions précises à lui poser | L'envoyer (semaine du 30/11) |
| Pas de bouton bloquer, pas de remplaçant | Legal, Operator | **Testeur référent bénévole** | ✅ Le blocage existait déjà (profil → ••• → Bloquer) ; consigne du remplaçant : [docs/consigne-moderation.md](docs/consigne-moderation.md) | Choisir le référent |
| Qui fait quoi, et qu'est-ce qui saute | Operator | — | ✅ [docs/planning-heures.md](docs/planning-heures.md) : 13 semaines, 122 h sur 130, ordre de ce qui saute | Le tenir |
| Coût d'une famille contre son prix | Operator | — | ✅ Onglet « Coût par famille » : **≈ 2,85 € par an** (photos, vidéos, frais de paiement) pour 24,17 € encaissés hors TVA | Le mesurer pour de vrai |
| Pas de vrai serveur ni de vrai téléphone | Operator | — | ✅ [docs/mise-en-production.md](docs/mise-en-production.md) : pas-à-pas Supabase, fonctions, Stripe, EAS | **À faire** (semaines du 16 et 23/11) |
| Chiffre de marché sourcé | Market | — | ✅ [docs/concurrents.md](docs/concurrents.md) : ≈ 7 millions de personnes d'origine africaine en France (Insee 2023-2024), 2,54 millions de Belges d'origine étrangère (Statbel 2024) — un **plafond**, pas une demande | La demande : la précommande la mesurera |

**Ce que le tableur dit maintenant, sans complaisance** : à l'année, une famille
rapporte ≈ 21 € de marge, mais il faut qu'**au moins 3,4 % des utilisateurs
actifs paient** pour couvrir les coûts de tous (à 10 000 actifs), contre 2,1 %
de conversion médiane dans le secteur. Le passage au prix annuel rend la
question plus dure, pas plus facile : la bêta doit faire mieux que la médiane.

