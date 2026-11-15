# Consigne du modérateur remplaçant

> Pour un ou deux testeurs de confiance, qui modèrent quand le fondateur est
> absent (vendredi soir, vacances). Une page, à lire avant d'accepter.

## Avant de commencer

- Le fondateur te donne le rôle (en SQL : `update profiles set is_moderator = true where username = '…';`).
- Dans l'app : **Profil → Modération**. Tu y vois les signalements ouverts, les plus anciens d'abord ; en rouge, ceux de plus de 24 h.
- Tu n'as accès à rien d'autre : ni e-mails, ni données privées, ni paiements.

## Ce qui est déjà automatique

- **« Un allergène n'est pas indiqué »** : la recette est **déjà masquée** dès
  le signalement. Ton rôle : vérifier.
  - L'allergène manque vraiment → **Masquer**, motif : « Allergène non indiqué (…). Corrigez la liste des ingrédients puis écrivez-nous. »
  - Le signalement est faux → **Classer** : la recette réapparaît toute seule.
- Le défi de la semaine change seul le lundi.

## Les autres signalements

| Motif | Tu masques si… | Motif à écrire |
| --- | --- | --- |
| Spam ou publicité | publicité non signalée, liens commerciaux répétés | « Publicité non signalée » |
| Insultant ou haineux | insulte, haine visant une origine, une religion, un genre… | « Propos haineux ou insultants » |
| Copié sans autorisation | texte ou photo manifestement repris d'un livre ou d'un site | « Contenu repris sans autorisation » |
| Dangereux pour la santé | cuisson dangereuse, conseil médical, ingrédient toxique | « Contenu dangereux pour la santé » |

**Dans le doute, tu ne tranches pas** : tu laisses ouvert et tu préviens le
fondateur. Tu ne supprimes jamais un compte, tu ne réponds jamais à la place de
couJina à un auteur.

## Après chaque passage

Noter dans [operations-hebdo.md](operations-hebdo.md) le temps passé et ce que tu
as masqué ou classé.
