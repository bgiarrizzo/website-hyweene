---
title: "Apple M1 : Comment installer psycopg2-binary"
summary: J'ai rencontré quelques difficultés en travaillant avec du code Python accédant à des bases de données PostgreSQL. Voici comment j'ai résolu le problème.
cover: "2021-10-17.png"
cover_alt: "couverture de l'article sur l'installation de psycopg2-binary sur mac m1"
publish_date: 2021-10-17T09:30:00+01:00
update_date: 2021-10-17T09:30:00+01:00
category: "Pense-bête"
tags: [apple, m1, postgres, python, psycopg2]

prism_needed: true
---

Le mois dernier, je me suis offert un Apple M1, un très bon ordinateur, puissant et avec une autonomie impressionnante.

Mon travail avec est assez simple, je code des API Python, quelques applications frontales simples avec TypeScript/React, j'essaie un peu de Go, j'apprends Swift et j'administre quelques clusters Kubernetes. Rien de trop sophistiqué.

J'essaie de travailler avec les dernières versions des logiciels que j'utilise, et dans ce cas, Python 3.10.

Je l'ai installé avec brew, assez facilement :

```bash
brew install python@3.10
```

J'ai eu des problèmes avec psycopg2-binary lors de l'installation des dépendances d'un des projets sur lesquels je travaille. Le message d'erreur que j'obtenais était celui-ci :

```bash
Error: pg_config executable not found.

pg_config is required to build psycopg2 from source.  Please add the directory
containing pg_config to the $PATH or specify the full executable path with the
option:

    python setup.py build_ext --pg-config /path/to/pg_config build ...

or with the pg_config option in 'setup.cfg'.
```

Il semble qu'il manque un fichier de configuration. J'ai essayé de résoudre ce problème en installant le serveur PostgreSQL pour obtenir ce fichier manquant :

```bash
brew install postgresql@12
```

À ce stade, brew me dit de configurer le chemin vers PG dans mon PATH, de cette façon (en utilisant ZSH, il me dit évidemment de l'écrire dans .zshrc) :

```bash
echo 'export PATH="/opt/homebrew/opt/postgresql@12/bin:$PATH"' > ~/.zshrc
```

Maintenant, tout est prêt, et je peux l'installer comme je le souhaite :

```bash
pip(3) install psycopg2-binary
```

Ou dans le répertoire de mon projet :

```bash
pipenv install psycopg2-binary
```
