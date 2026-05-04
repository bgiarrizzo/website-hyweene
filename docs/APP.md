# APP

## Objectif

Ce projet génère un site statique personnel (hyweene.fr) à partir de contenu Markdown/YAML et de templates Stencil.

## Comportement principal

- Génération structurée par sections: blog, liens, pages, CV, apprentissage.
- Publication dans un dossier horodaté de `releases/`.
- Mise à jour atomique du symlink `current` vers la dernière release valide.

## Commandes utilisateur

- `hyweene build`
- `hyweene dev --host <host> --port <port>`
- `hyweene quick-add-link <url> [--comment <text>]`
- `hyweene check-dead-links [--path <dir>]`

## Mode développement

Le mode dev fait un build initial, sert le dossier `current`, puis reconstruit à chaque changement dans:

- `content/`
- `generator/Templates/`
