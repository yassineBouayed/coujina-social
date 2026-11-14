# couJina social

Le réseau social des passionnés de cuisine : des recettes et des vidéos de 50
pays, que l'on enregistre, que l'on modifie en gardant le crédit de leur
auteur, et que l'on partage avec qui l'on veut.

- **[ETAT.md](ETAT.md)** — ce qui est fait, ce qui ne l'est pas, ce qui manque pour la production.
- **[docs/plan-de-test.md](docs/plan-de-test.md)** — le plan de test et les données fictives.
- **[mobile/](mobile)** — l'application Expo / React Native (SDK 57).
- **[supabase/](supabase)** — le schéma (migrations), les tests SQL, l'amorçage généré.
- **[data/](data)** — le livre de 1 039 recettes, les cuisines, les pays, le référentiel d'ingrédients, et [`data/fictive/`](data/fictive) : les personnes et recettes fictives.
- **[tools/](tools)** — générateurs d'amorçage et banc de test SQL.
- **[design/](design)** — les planches de la charte couJina.

Né du projet « application pour famille » : voir ETAT.md §1 pour ce qui en a été repris.

## Les cinq onglets

| Onglet | Écran | Fichier |
|---|---|---|
| Accueil | Recettes et vidéos selon mes cuisines, sans ce que je ne mange pas | `mobile/app/(tabs)/index.tsx` |
| Tour du monde | Un globe à faire tourner, une épingle par pays | `mobile/app/(tabs)/explore.tsx` |
| Mes recettes | Écrites et enregistrées, avec leur confidentialité | `mobile/app/(tabs)/mine.tsx` |
| Tendances | Les plus copiées du jour, de la semaine, du mois | `mobile/app/(tabs)/top.tsx` |
| Profil | Compteurs, préférences, langue, compte | `mobile/app/(tabs)/profile.tsx` |

Et : `sign-in`, `onboarding/cuisines` puis `onboarding/diet`, `recipe/[id]`,
`recipe/edit`, `user/[id]`, `country/[slug]`, `search`, `profile-edit`.

## Démarrer

```bash
npm install
npm run seed       # -> supabase/seed/*.generated.sql et mobile/src/mock/mock.generated.ts
npm run db:test    # PostgreSQL embarqué : migrations, amorçage x2, tests SQL
```

```bash
cd mobile
npm install
npm start          # puis i / a, ou le QR code dans Expo Go
npm run web        # le plus rapide pour cliquer sur un portable
```

Sans `mobile/.env`, l'application tourne en **mode démo** sur les données
fictives : l'écran de connexion propose trois comptes (Amina, Tom, Marie).
Copier `mobile/.env.example` vers `mobile/.env` pour la brancher sur un projet
Supabase.

## Sur un projet Supabase

```bash
supabase link --project-ref <ref>
supabase db push
psql "$DATABASE_URL" -f supabase/seed/catalog.generated.sql
psql "$DATABASE_URL" -f supabase/seed/fictive.generated.sql   # projet de TEST seulement
SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… npm run seed:accounts   # idem
```

Dans le tableau de bord : *Authentication → Providers* → Email (confirmation
activée, le modèle d'e-mail doit contenir `{{ .Token }}`), Google, Apple ;
*URL Configuration* → ajouter `coujinasocial://auth-callback`.

## Où vivent les règles

Toutes les règles qui comptent sont en SQL, et testées :

| Règle | Où |
|---|---|
| Qui voit quelle recette (publique / abonnés / moi seul, blocages) | `can_view_recipe()` et la RLS — `supabase/migrations/…_recettes.sql`, `…_social.sql` |
| Copier telle quelle, copier modifiée, le crédit | `copy_recipe()`, `recipe_save()` |
| Une copie n'est jamais plus ouverte que l'original | idem, et `recipe_set_visibility()` |
| L'accueil | `home_feed()` |
| Les classements | `trending_recipes()` |
| Le globe | `globe_countries()`, `country_recipes()` |
| Les drapeaux alimentaires | `detect_flags()` + le rattachement de `tools/seed/` pour le livre |

Le mode démo (`mobile/src/api.mock.ts`) redit ces règles en TypeScript pour
qu'on puisse cliquer sans serveur ; **le SQL fait foi**.
