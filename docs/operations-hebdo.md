# Les opérations de la semaine

> La question de l'Operator Shark : « qui fait le travail le lundi ? ».
> Réponse : le fondateur, seul, **2 heures par semaine** prises sur ses 10.
> Un signalement est traité **sous 24 heures**.

## Ce qu'il y a à faire

| Tâche | Fréquence | Temps | Où |
| --- | --- | --- | --- |
| Lire la file des signalements, masquer (avec un motif) ou classer | chaque jour | 10 min | Profil → Modération |
| Regarder les recettes et vidéos publiées depuis la veille | chaque jour | 5 min | Accueil, filtre « Vidéos » |
| Relire les photos masquées du livre (230 au départ) | 4 semaines × 1 h | 1 h | `data/images/a-revoir.csv`, puis `valide.txt` |
| Le défi de la semaine | — | 0 | il change tout seul le lundi |
| Noter la semaine (ci-dessous) | le lundi | 10 min | ce fichier |

Pour donner le rôle de modérateur (une seule fois, en SQL) :
`update profiles set is_moderator = true where username = '…';`

## La feuille de la semaine

Les colonnes « reçus » à « masquées » se recopient de l'écran Modération (ligne
« Cette semaine ») ou de `select * from ops_weekly(8);`. Les heures réelles se
notent à la main : c'est le chiffre que l'Operator Shark veut voir.

| Semaine du | Signalements reçus | Traités | Sous 24 h | Encore ouverts | Recettes masquées | Photos relues | Heures réelles | Remarques |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 13/01/2027 | | | | | | | | |
| 20/01/2027 | | | | | | | | |
| 27/01/2027 | | | | | | | | |
| 03/02/2027 | | | | | | | | |

**Alerte** : si les heures réelles dépassent 3 h deux semaines de suite, ou si un
signalement dépasse 24 h, le noter ici et le dire dans le bilan de la bêta.
