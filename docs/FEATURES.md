# FEATURES

## Génération de contenu

- Blog: articles, pages catégories, liste, RSS, sitemap
- Liens: pages individuelles, liste, RSS, sitemap
- Pages statiques: about/now/projets et assimilées
- Apprentissage: modules, tables des matières, pages
- CV: génération de la page résumé

## Performance

- Générateurs indépendants exécutés en parallèle
- Rendu parallèle des items indépendants (posts, liens, pages, modules)

## Commandes CLI

- `hyweene build`: build unique
- `hyweene dev --host <host> --port <port>`: build + watch + serveur local
- `hyweene quick-add-link <url> [--comment <text>]`: crée un nouveau fichier de lien à partir du titre de la page distante
- `hyweene check-dead-links [--path <dir>]`: détecte les liens externes morts (404) dans les HTML générés

## Automatisation projet

- Tâches de projet exposées via `mise` (`mise run install|setup|build|dev|test|serve|quick_add_link`)

## Fiabilité de publication

- Build dans un dossier horodaté
- Bascule via symlink `current`
- Nettoyage automatique des releases anciennes
