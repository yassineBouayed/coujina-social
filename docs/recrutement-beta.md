# Recruter les 20 cuisiniers

> Décidé le 15/11/2026 : une annonce payée de **200 €**, un **formulaire de
> sélection**, **30 invités** pour en garder 20 actifs, **France et Belgique**.
> Bêta du **13/01 au 10/02/2027**.

## Calendrier

| Date | Étape |
| --- | --- |
| 01/12/2026 | Annonce en ligne (Instagram et Facebook, France + Belgique) |
| 31/12/2026 | Fin de l'annonce ; tri des candidatures |
| 05/01/2027 | 30 invitations envoyées (lien TestFlight / APK) |
| 10/01/2027 | Recrutement clos ; inscription des comptes dans `beta_testers` |
| 13/01/2027 | Début de la bêta |
| 10/02/2027 | Fin de la bêta ; entretiens de 15 min avec 8 testeurs |
| 31/03/2027 | Décision (voir [engagement.md](engagement.md)) |

## L'annonce

- **Budget** : 200 €, du 01/12 au 31/12/2026 (≈ 6,50 €/jour).
- **Ciblage** : France + Belgique ; 20 à 55 ans ; centres d'intérêt cuisine
  marocaine, algérienne, tunisienne, sénégalaise, ivoirienne, libanaise,
  indienne, antillaise, cuisine du monde.
- **Message** (une seule version) : « Les recettes de votre famille méritent
  mieux qu'un carnet qui jaunit. Testez couJina pendant un mois, avant tout le
  monde : 20 places. »
- **Lien** : le formulaire ci-dessous (Tally ou Google Forms : gratuit, hébergé
  dans l'UE pour Tally).
- **À noter dans le modèle économique** : coût par candidature et par testeur
  actif (onglet « À mesurer en bêta » de [modele-economique.xlsx](modele-economique.xlsx)).

## Le formulaire de sélection

1. Prénom et e-mail.
2. Vous avez 15 ans ou plus ? (oui / non — non = fin)
3. Pays : France / Belgique / autre (autre = liste d'attente)
4. Combien de fois cuisinez-vous par semaine ? (0-1 / 2-3 / 4 et plus)
5. Quelle cuisine vient de votre famille ? (texte libre)
6. Publiez-vous déjà vos recettes quelque part ? (Instagram, TikTok, groupe
   WhatsApp ou Facebook, blog, non)
7. **Avez-vous des recettes de vos parents ou grands-parents que vous avez peur
   de perdre ?** (oui, beaucoup / quelques-unes / non) — *c'est la question du
   « pourquoi maintenant » du Market Shark.*
8. iPhone ou Android ?
9. Connaissez-vous personnellement le créateur de couJina ? (oui / non — oui =
   écarté, l'entourage ne mesure rien)

**Sélection des 30** : 4 fois et plus par semaine en priorité, puis ceux qui
publient déjà, en mélangeant au moins 5 cuisines et en respectant à peu près la
part iPhone / Android des candidats. Garder les suivants en liste d'attente.

**Contrepartie** : leur nom dans les crédits de l'application et **un an de
Premium offert** (posé en base : `update profiles set premium_until = '2028-01-13'`).
Pendant la bêta, tous les testeurs ont le Premium, pour pouvoir essayer le livre
de famille ; la question du prix mesure s'ils le **paieraient**.

## Message d'invitation

> Bonjour {prénom}, merci pour votre candidature : vous faites partie des 20 !
> couJina est un réseau de recettes où chaque version garde le nom de qui l'a
> créée, et où votre famille peut ranger ses recettes dans un livre privé. Le
> test dure un mois, du 13 janvier au 10 février. Votre lien : {lien}. La seule
> chose qu'on vous demande : l'utiliser comme vous en avez envie, et nous dire
> franchement ce qui ne va pas. Un an de Premium vous est offert.
