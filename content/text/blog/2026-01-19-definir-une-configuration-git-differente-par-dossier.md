---
title: "Pense-bête: Définir une configuration git différente par dossier"
summary: "Comment définir une configuration git différente par dossier."
publish_date: 2026-01-19T09:30:00+01:00
update_date: 2026-01-19T09:30:00+01:00
category: "Pense-bête"
tags: [git, configuration, dossier]

prism_needed: true
---

## Contexte

J'ai un ordinateur, qui me sert à bosser à la fois sur des projets pro et perso.

Pour des raisons évidentes, je ne veux pas commit de fichiers sur des répos pro, avec mon adresse email perso, et inversement.

## Solution

Git permet de définir une configuration différente par dossier, en utilisant un fichier `.gitconfig` local.

Ma configuration git principale (présente dans `~/.config/git/config`), inclut un autre fichier de configuration, uniquement pour les répos présents dans un dossier spécifique.

```ini 
[user]
    name = Bruno Giarrizzo
    email = bruno@chezmoi.fr

[includeIf "gitdir:~/code/pro/**"]
    path = ~/code/pro/.gitconfig
```

Il suffit de créer un fichier `.gitconfig` référencé dans l'includeIf dans le dossier qui contient les différents repos : 

```ini 
[user]
    email = bruno.giarrizzo@mail-du-boulot.fr
```

Maintenant, quand je suis dans le dossier `~/code/pro/mon-repo`, git utilisera l'email `bruno.giarrizzo@mail-du-boulot.fr` pour les commits, et dans les autres dossiers, l'email `bruno@chezmoi.fr`.

Pour vérifier la configuration utilisée dans un répo, il suffit d'utiliser la commande : 

```bash
git config --list --show-origin
```

On peut voir que la configuration est la suivante : 

```
file:/Users/bgiarrizzo/.config/git/config     user.name=Bruno Giarrizzo
file:/Users/bgiarrizzo/.config/git/config     user.email=bruno@chezmoi.fr
file:/Users/bgiarrizzo/.config/git/config     user.signingkey=blablabla
file:/Users/bgiarrizzo/.config/git/config     commit.gpgsign=true
...
file:/Users/bgiarrizzo/.config/git/config     includeif.gitdir:~/code/pro/**.path=~/code/pro/.gitconfig
```

Et maintenant, une fois placé dans un répo du dossier `~/code/pro/` : 

```
file:/Users/bgiarrizzo/.config/git/config     user.name=Bruno Giarrizzo
file:/Users/bgiarrizzo/.config/git/config     user.email=bruno@chezmoi.fr
file:/Users/bgiarrizzo/.config/git/config     user.signingkey=blablabla
file:/Users/bgiarrizzo/.config/git/config     commit.gpgsign=true
...
file:/Users/bgiarrizzo/.config/git/config     includeif.gitdir:~/code/pro/**.path=~/code/pro/.gitconfig
file:/Users/bgiarrizzo/code/pro/.gitconfig    user.email=bruno.giarrizzo@mail-du-boulot.fr
```

On voit bien que l'email a été surchargé par le fichier de configuration local.
