# Hyweene Static Site Generator

Générateur de site statique en Swift pour hyweene.fr.

## Commandes CLI

Le binaire `hyweene` expose maintenant quatre commandes explicites :

```bash
hyweene build
hyweene dev --host 0.0.0.0 --port 1234
hyweene quick-add-link https://example.com
hyweene quick-add-link https://example.com --comment "Great read"
hyweene check-dead-links --path ./current
```

Comportement :
- `build` : génère le site une fois, met à jour le symlink `current`, et nettoie les anciennes releases.
- `dev` : lance un build initial, démarre un serveur HTTP local, puis reconstruit automatiquement quand un fichier change.
- `quick-add-link` : récupère le titre d'une URL puis crée automatiquement un fichier Markdown dans `content/text/links`.
    - mode interactif: demande un commentaire
    - mode non interactif: `--comment "..."`
- `check-dead-links` : analyse les fichiers HTML générés et liste les liens externes en erreur 404 (JSON en sortie).

## Fonctionnalités

- Parsing Markdown + frontmatter YAML
- Templates Stencil
- Génération des sections blog, liens, pages, CV et apprentissage
- RSS + sitemaps
- Build parallèle :
    - générateurs indépendants en parallèle
    - posts blog en parallèle
    - liens en parallèle
    - modules/pages d'apprentissage en parallèle
    - pages statiques en parallèle
- Mode développement avec watch + serveur local

## Utilisation via mise

```bash
mise run install
mise run setup
mise run build
mise run dev
mise run test
```

## Utilisation directe

```bash
cd generator
swift build

# Build unique
./.build/debug/hyweene build

# Mode dev
./.build/debug/hyweene dev --host 0.0.0.0 --port 1234

# Ajouter un lien rapidement
./.build/debug/hyweene quick-add-link https://example.com
./.build/debug/hyweene quick-add-link https://example.com --comment "Great read"

# Vérifier les liens morts
./.build/debug/hyweene check-dead-links --path ./current
```

## Tests

```bash
cd generator
swift test
```

## Compatibilité

- Swift 6+
- macOS 15+