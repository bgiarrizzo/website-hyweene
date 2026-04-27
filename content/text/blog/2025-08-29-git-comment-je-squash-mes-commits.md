---
title: "Git : Comment je squash mes commits"
summary: "Squasher ses commits pour une meilleure lisibilité"
publish_date: 2025-08-29T11:30:00+01:00
update_date: 2025-08-29T11:30:00+01:00
category: "Pense-bête"
tags: [git, commit, squash]

prism_needed: true
---

## Pourquoi squasher ses commits ?

Squasher ses commits permet de garder un historique propre, lisible, et compréhensible. Cela permet de garder une trace de l'évolution du code, sans encombrer l'historique de commits inutiles.

## Mes deux méthodes préférées

Il y a deux méthodes que je préfère pour squasher mes commits, une rapide, et une, rapide également, mais plus complète.

### Méthode Rapide

Dans cette méthode, j'ai juste une liste de commits à squasher (3, 4, ou plus), et je veux les fusionner en un seul commit.

D'abord je liste mes commits, avec git log par exemple :

```bash
bgiarrizzo@cloe:~/code/test$ git log --oneline --graph --decorate
* a8cc58e (HEAD -> main) fix4
* a0a31be fix3
* b6a85bc fix2
* e8da457 fix
* 27447d0 Ma feature
* aa9cc7b Premier Commit
```

Cette commande m'affiche la liste de mes commits, leur id et leur message.

On peut aussi utiliser tig, qui fait la même chose, mais avec une interface graphique :

```bash
tig
```

Je copie l'id du commit de base, dans mon cas 27447d0.
Ensuite, je lance la commande git rebase -i avec l'id du commit de base :

```bash
git rebase -i 27447d0
```

Vim s'ouvre avec la liste des commits à squasher :

```bash
pick 27447d0 Ma feature
pick e8da457 fix
pick b6a85bc fix2
pick a0a31be fix3
pick a8cc58e fix4

[...]
```

Je remplace pick par squash pour les commits que je veux fusionner :

```bash
pick 27447d0 Ma feature
s e8da457 fix
s b6a85bc fix2
s a0a31be fix3
s a8cc58e fix4
```

Je sauvegarde et ferme vim, un autre vim s'ouvre pour me demander le message du commit final.

Comme je n'aime pas les long messages de commit, je garde juste le message du premier commit, et je supprime (ou commente) les autres lignes.

```bash
# This is a combination of 5 commits.
# This is the 1st commit message:

Ma feature

# This is the commit message #2:

fix

# This is the commit message #3:

fix2

# This is the commit message #4:

fix3

# This is the commit message #5:

fix4

[...]
```

Je sauvegarde et ferme vim, git termine le rebase.

Pour terminer, je check l'historique avec git log pour vérifier que tout est ok :

```bash
bgiarrizzo@cloe:~/code/test$ git log --oneline --graph --decorate
* 450009b (HEAD -> main) Ma feature
* aa9cc7b Premier Commit
```

### Méthode Complète

Dans cette méthode, j'ai toujours 3, 4, ou plus de commits à squasher, mais dedans s'est glissé un commit de merge. Je veux fusionner tous les commits en un seul, mais je veux aussi supprimer le commit de merge.

D'abord il faut récupérer l'id du commit de base de la branche en cours, je fais ca avec git merge-base :

```bash
git merge-base brancheEnCours branchePrincipale
```

Ce qui donne dans mon repo :

```bash
git merge-base feature main
```

Ensuite, je lance la commande git rebase -i avec l'id du commit de base :

```bash
git rebase -i idDuCommitDeBase
```

Vim s'ouvre avec la liste des commits à squasher, je remplace pick par squash pour les commits que je veux fusionner.

Pour terminer, je push avec l'option force :

```bash
git push origin main --force
```

## Conclusion

J'avoue préférer la méthode complète, car étrangement plus facile à retenir pour moi. Et elle me fait gagner du temps :)
