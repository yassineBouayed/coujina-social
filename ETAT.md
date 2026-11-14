# couJina social — état du projet

> Mis à jour le 14/11/2026. Nouveau projet, né de l'ancien « application pour
> famille » (couJina, gestion de foyer) : l'idée a changé, on garde ce qui sert
> un **réseau social de cuisine grand public** et on laisse le reste.

**Légende** — ✅ fait et vérifié · 🟡 écrit mais pas vérifié en conditions réelles · ❌ pas fait

**Ce qui a été vérifié, et comment**

| Vérification | Résultat |
|---|---|
| `npm run db:test` — 3 migrations, 2 amorçages joués deux fois (idempotence), 7 fichiers de tests SQL | ✅ tout passe |
| `npm run typecheck` (TypeScript strict) dans `mobile/` | ✅ aucune erreur |
| Application web en **mode démo** (sans Supabase), taille téléphone : connexion démo → cuisines → interdits → accueil → fiche → « Enregistrer » → globe (toucher, faire tourner) → tendances → attribution « modifiée par » | ✅ parcours joué dans le navigateur |
| Projet Supabase réel, connexion Google / Apple / e-mail, envoi de photos et de vidéos, iPhone et Android | ❌ **jamais joué** : aucun projet Supabase n'existe encore pour ce produit |

---

## 1. Ce qui a été repris de l'ancien projet

| Repris | D'où | Ce qui a changé |
|---|---|---|
| **Le livre : 1 039 recettes**, 16 cuisines, 50 pays, 5 continents | `data/recipes/**`, `data/*.psv` | Les pays ont reçu des coordonnées (lat/lng) pour le globe. Les recettes deviennent des publications du compte éditorial `@coujina`, en français. |
| Le référentiel d'ingrédients et ses synonymes, et le **rattachement automatique** | `data/ingredients.psv`, `tools/probe/`, `tools/refdata/` | Sert désormais à calculer les **drapeaux alimentaires** de chaque recette. Nouveau drapeau `meat` (viande), déduit des catégories viandes / volailles / charcuterie : il rend possible « végétarien ». |
| 1 008 **images candidates** Wikimedia | `plats-images.txt` | Copiées dans `cover_url`. ⚠️ Voir §4 : licences et pertinence à vérifier. |
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
- ❌ **Images Wikimedia** : elles sont sous licences Creative Commons qui **exigent l'attribution** (auteur, licence), et certaines ne montrent pas le bon plat (« Flan coco » → une photo de halo-halo). Il faut les relire une à une, afficher le crédit, ou les remplacer.
- ❌ **Médias privés** : le bucket est public. L'adresse d'une photo d'une recette « Moi seul » est lisible par qui la connaît. Passer aux URL signées.
- ❌ **Conditions d'utilisation, politique de confidentialité, âge minimum** (15 ans en France sans accord parental), page de contact.
- ❌ **Modération** : les signalements sont enregistrés, mais personne ne les lit — il faut un outil d'administration, et un filtrage automatique des textes et des images.
- ❌ **Export des données personnelles** (RGPD, droit d'accès) — la suppression, elle, existe.
- ❌ Essais sur **vrais téléphones** iOS et Android, en particulier caméra, envoi de vidéo et connexion Google / Apple.

**Important, juste après**

- ❌ Vidéo : compression, miniature, envoi reprenable (le fichier est aujourd'hui lu entier en mémoire), quotas, nettoyage du stockage quand une recette est supprimée. Les copies pointent vers les fichiers de l'original : s'il les supprime, l'image disparaît chez les copieurs.
- ❌ Recherche de recettes par mot (seule la recherche de personnes existe).
- ❌ Notifications (nouvel abonné, recette copiée).
- ❌ Protection contre les abus : limite de débit, comptes multiples pour gonfler les classements.
- ❌ Suivi des plantages et des performances (Sentry ou équivalent), analytique respectueuse du consentement.
- ❌ Intégration continue : `db:test` et `typecheck` à chaque commit.
- ❌ Accessibilité relue, vraies icônes à la place des glyphes de la barre d'onglets.
- ❌ Contenu en anglais : le livre est en français seulement (l'ancien projet avait les deux langues ; le nouveau schéma ne garde qu'une langue par recette).
- ❌ Montée en charge : l'accueil et les classements sont calculés à la demande ; au-delà de quelques dizaines de milliers de recettes, il faudra des vues matérialisées.
- ❌ Fiches App Store / Google Play à réécrire pour le nouveau produit.
