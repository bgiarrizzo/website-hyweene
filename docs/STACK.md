# STACK

## Langage et runtime

- Swift 6
- Swift Package Manager

## Bibliothèques

- Ink (Markdown)
- Yams (YAML)
- Stencil (templates)
- Swift Testing (tests, via toolchain or `swift-testing` package fallback)
- FoundationNetworking (Linux, pour les APIs URLSession/URLRequest)

## Outils et patterns

- Task runner: `mise` (`mise.toml`)
- CLI custom (`hyweene build`, `hyweene dev`, `hyweene quick-add-link [--comment <text>]`, `hyweene check-dead-links`)
- Exécuteur concurrent pour tâches indépendantes
- Watcher par snapshot + polling
- Serveur HTTP local minimal via `Network` avec fallback Swift natif (sockets POSIX) si `Network` n'est pas disponible (ex: Linux)
