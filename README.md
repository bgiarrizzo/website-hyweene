# SiteGenerator

Générateur de site statique en Swift pour Hack With Hyweene.

## Fonctionnalités

- ✅ Parsing Markdown avec support Prism.js pour le code
- ✅ Templates Stencil (compatible Jinja2)  
- ✅ Génération multi-types : blog, liens, pages, CV, modules  d'apprentissage
- ✅ Sitemap XML automatique
- ✅ RSS feeds
- ✅ Cross-platform (macOS + Linux)
- ✅ Swift 6 avec strict concurrency

## Installation

```bash
# Installer les dépendances
make install

# Compiler et générer le site
make build

# Lancer les tests de validation
make test
```

## Architecture

```
Sources/SiteGenerator/
├── Models/          # BlogPost, LinkItem, Page, Resume, LearnModule
├── Generators/      # BlogGenerator, LinksGenerator, etc.
├── Templates/       # TemplateEngine (Stencil)
├── Parsers/         # MarkdownParser, PrismCodeProcessor
├── Utils/           # DateFormat, String extensions
└── main.swift       # Point d'entrée

Tests/
├── validate.sh      # Script de validation end-to-end
└── README.md        # Documentation des tests
```

## Dépendances

- **Ink** : Parsing Markdown
- **Stencil** : Moteur de templates
- **Yams** : Parsing YAML (frontmatter)

## Tests

### Framework

Ce projet utilise **Swift Testing**, le framework de tests moderne inclus dans Swift 6.

Architecture des tests :
```
Tests/SiteGenerator_Tests/
├── Utils/
│   ├── DateFormatTests.swift      (15 tests)
│   └── StringExtensionsTests.swift (20 tests)
├── Parsers/
│   └── MarkdownParserTests.swift   (13 tests)
└── Templates/
    └── TemplateEngineTests.swift   (5 tests)
```

### Utilisation

```bash
# Via Makefile (recommandé)
make test                # Tests unitaires
make test-verbose        # Tests avec détails

# Directement avec Swift
cd generator
swift test
swift test --verbose
swift test --filter DateFormat    # Tests spécifiques
```

### Couverture des tests

#### Utils (35 tests)

**DateFormat (15 tests)**
- Parsing ISO8601 : avec/sans timezone, différents formats
- Support Date objects (important pour Yams YAML parser)
- Formats de sortie : short, medium, long, RFC3339
- Extensions Date : year(), month()
- Validation : isDateOlderThanSixMonths()

**StringExtensions (20 tests)**
- `slugified()` : accents, caractères spéciaux, espaces multiples
- Exemples réels : "Git : Comment je squash..." → "git-comment-je-squash..."
- `estimatedReadingTime()` : calcul basé sur nombre de mots
- `strippingHTML()` : suppression tags HTML

#### Parsers (13 tests)

**MarkdownParser**
- YAML frontmatter : valid, empty, multiline, Date vs String
- Markdown → HTML : headings, lists, links, formatting
- Code blocks : avec/sans langage, Prism.js classes

#### Templates (5 tests)

**TemplateEngine**
- Rendu variables : `{{ name }}`
- Boucles : `{% for item in items %}`
- Conditions : `{% if show %}`

### Bonnes pratiques

- Tests utilisent `@Test("Description")` pour clarté
- Fixtures temporaires (FileManager.temporaryDirectory) pour I/O
- Assertions avec `#expect()` (syntaxe moderne Swift Testing)
- Tests couvrent les cas limites et le comportement réel de l'implémentation

## Compatibilité

- **Swift** : 6.0+
- **macOS** : 13+ (Ventura)
- **Linux** : via Docker (swift:5.10 image)