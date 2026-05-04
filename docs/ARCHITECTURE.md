# ARCHITECTURE

## Vue d'ensemble

Le générateur est organisé en deux couches:

- Librairie `HyweeneSiteGenerator` (logique métier testable)
- Exécutable `hyweene` (routing CLI)

## Pipeline de build

1. Copie des assets (`content/media`, `content/static`)
2. Générateurs indépendants en parallèle:
   - BlogGenerator
   - LinksGenerator
   - PagesGenerator
   - LearnGenerator
   - ResumeGenerator
3. Générateurs dépendants en séquentiel:
   - HomepageGenerator (dépend blog + links)
   - SitemapGenerator
4. Publication:
   - mise à jour du symlink `current`
   - nettoyage des anciennes releases

## Parallélisation

La parallélisation repose sur un exécuteur concurrent dédié:

- Boucles parallèles pour posts, liens, modules/pages et pages statiques
- Propagation d'erreur au premier échec
- Arrêt des opérations restantes dès erreur

## Mode dev

Le mode dev combine:

- Build initial
- Serveur HTTP local minimal (`Network` sur Apple platforms, fallback Swift natif (sockets POSIX) sur Linux)
- Watcher par snapshot (polling) avec debounce 500 ms
- Rebuild à la détection de changement

Le serveur continue de servir la dernière release valide si un rebuild échoue.

## Outils de liens CLI

Le runtime CLI inclut aussi des commandes de maintenance de contenu:

- `quick-add-link`: récupération du titre HTML distant + génération d'un fichier markdown de lien (interactif ou non interactif avec `--comment`)
- `check-dead-links`: scan récursif des HTML générés + détection des liens externes en 404
