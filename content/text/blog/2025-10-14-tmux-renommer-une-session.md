---
title: "Tmux : Renommer une session"
summary: Un petit pense bête pour renommer une session tmux.
publish_date: 2025-10-14T14:30:00+01:00
update_date: 2025-10-14T14:30:00+01:00
category: "Pense-bête"
tags: [tmux, terminal, productivité]
prism_needed: true
---

Je découvre TMUX depuis quelques jours. J'aime beaucoup, j'y place un weechat, pour acceder à mes serveurs/channels IRC, et j'ai aussi un newsboat, pour lire mes flux RSS, ces softs sont du coup, toujours ouverts, et je peux y accéder de n'importe où, tant que j'ai accès au port SSH de mon serveur perso.

J'ai trouvé une cheat sheet très complète ici : [https://tmuxcheatsheet.com/](https://tmuxcheatsheet.com/)

Donc, petit pense bête pour renommer une session tmux.

Quand on démarre une nouvelle session tmux, elle porte un nom par défaut, souvent "0", "1" ... Mais, pour utiliser un nom plus parlant, je créé une nouvelle session avec un id custom, comme ceci : 

```bash
$ tmux new -s mon_nom_de_session
```

Sauf que parfois, je ne suis pas super inspiré à la création, et il arrive que quelques jours après, je me rende compte que le nom pue un peu. Il faut donc renommer !

Pour ça, il y a deux méthodes.

## Méthode 1 : Depuis l'extérieur d'une session tmux

Si on est pas dans une session tmux, on peut renommer une session en utilisant la commande `tmux rename-session -t <ancien_nom> <nouveau_nom>`

On vérifie d'abord le nom de la session avec `tmux ls` ou `tmux list-sessions` :

```bash
$ tmux ls
un_nom_de_session_nul: 2 windows (created Wed Oct 14 14:02:18 2025)
```

```bash
$ tmux rename-session -t un_nom_de_session_nul un_nouveau_nom_qui_claque
```

Et en listant les sessions avec soit `tmux ls` ou `tmux list-sessions`, on voit que le nom a changé.

```bash
$ tmux ls
un_nouveau_nom_qui_claque: 2 windows (created Wed Oct 14 14:02:18 2025)
```

## Méthode 2 : Depuis une session tmux

On peut renommer la session en utilisant la commande `tmux rename-session`, soit :

- en utilisant l'ancien nom, puis le nouveau nom
- en précisant tout de suite le nouveau nom, si on est dans la session à renommer

```bash
# Depuis une autre session tmux
$ tmux rename-session -t un_nom_de_session_nul un_nouveau_nom_qui_claque
```

```bash
# Depuis la session à renommer
$ tmux rename-session un_nouveau_nom_qui_claque
```

On peut aussi utiliser le raccourci clavier `prefix + $` (par défaut, `Ctrl + b`, puis `$`), qui ouvre une invite de commande en bas de l'écran, où on peut taper le nouveau nom de la session.