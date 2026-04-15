# Configuration via Variables d'Environnement

Le générateur de site supporte maintenant la configuration via des variables d'environnement, similaire à Pydantic en Python.

## Fonctionnement

Toutes les propriétés de configuration peuvent être surchargées via des variables d'environnement. Si une variable n'est pas définie, la valeur par défaut est utilisée.

## Variables Disponibles

### URL Configuration

| Variable | Défaut | Description |
|----------|--------|-------------|
| `SITE_SCHEME` | `https` | Protocole du site |
| `SITE_SHORT_URL` | `hyweene.fr` | URL courte du site |
| `SITE_LONG_URL` | `www.hyweene.fr` | URL complète du site |
| `SITE_BASE_URL` | `https://www.hyweene.fr` | URL de base complète |

### Paths Configuration

| Variable | Défaut | Description |
|----------|--------|-------------|
| `SITE_RELEASES_PATH` | `releases` | Dossier des releases |
| `SITE_CURRENT_RELEASE_PATH` | `build` | Nom du symlink vers la release actuelle |
| `SITE_CONTENT_PATH` | `content` | Dossier racine du contenu |
| `SITE_MEDIA_PATH` | `content/media` | Dossier des médias |
| `SITE_STATIC_PATH` | `content/static` | Dossier des fichiers statiques |
| `SITE_TEMPLATE_PATH` | `generator/Templates` | Dossier des templates |
| `SITE_TEXT_CONTENT_PATH` | `content/text` | Dossier du contenu texte |
| `SITE_BLOG_PATH` | `content/text/blog` | Dossier des articles de blog |
| `SITE_LINKS_PATH` | `content/text/links` | Dossier des liens |
| `SITE_PAGES_PATH` | `content/text/pages` | Dossier des pages |
| `SITE_RESUME_PATH` | `content/text/resume` | Dossier du CV |
| `SITE_LEARN_PATH` | `content/text/learn` | Dossier des modules d'apprentissage |

### Author Information

| Variable | Défaut | Description |
|----------|--------|-------------|
| `SITE_AUTHOR_NAME` | `Bruno Giarrizzo` | Nom de l'auteur |
| `SITE_AUTHOR_FULL` | `Bruno 'Hyweene' Giarrizzo` | Nom complet de l'auteur |
| `SITE_GITHUB_LINK` | `https://github.com/bgiarrizzo/` | Lien GitHub |
| `SITE_LINKEDIN_LINK` | `https://www.linkedin.com/in/bruno-giarrizzo/` | Lien LinkedIn |

### Site Metadata

| Variable | Défaut | Description |
|----------|--------|-------------|
| `SITE_DESCRIPTION` | `Linuxien, Developpeur Python, Swift et DevOps` | Description du site |
| `SITE_KEYWORDS` | `Bruno,Giarrizzo,...` | Mots-clés (séparés par des virgules) |
| `SITE_LANGUAGE` | `fr-FR` | Langue du site |
| `SITE_LOCALE` | `fr_FR.UTF-8` | Locale du site |

## Utilisation

### 1. Via fichier .env

Copiez `.env.example` vers `.env` et personnalisez les valeurs :

```bash
cp .env.example .env
# Éditez .env avec vos valeurs
```

Puis sourcez le fichier avant de lancer le générateur :

```bash
export $(cat .env | xargs)
swift run HyweeneSiteGeneratorBin
```

### 2. Via export direct

```bash
export SITE_AUTHOR_NAME="Mon Nom"
export SITE_SHORT_URL="monsite.com"
export SITE_KEYWORDS="Mot1,Mot2,Mot3"
swift run HyweeneSiteGeneratorBin
```

### 3. Via commande en une ligne

```bash
SITE_AUTHOR_NAME="Mon Nom" swift run HyweeneSiteGeneratorBin
```

### 4. Via Make

Ajoutez dans votre Makefile :

```makefile
.PHONY: build-dev
build-dev:
	@export SITE_BASE_URL="http://localhost:8000" && \
	swift run HyweeneSiteGeneratorBin

.PHONY: build-prod
build-prod:
	@export SITE_BASE_URL="https://www.hyweene.fr" && \
	swift run HyweeneSiteGeneratorBin
```

## Format des Valeurs

### Strings
Valeurs simples : `SITE_AUTHOR_NAME="Mon Nom"`

### Arrays
Séparées par des virgules : `SITE_KEYWORDS="Mot1,Mot2,Mot3"`

Les espaces autour des virgules sont automatiquement supprimés.

## Tests

Les tests unitaires vérifient que :
- Les valeurs par défaut sont correctes
- Les variables d'environnement peuvent être lues
- Les types de données sont corrects (strings, arrays)

Lancez les tests avec :

```bash
swift test
```

## Exemple Complet

```bash
# Configuration pour développement local
export SITE_SCHEME="http"
export SITE_SHORT_URL="localhost:8000"
export SITE_BASE_URL="http://localhost:8000"
export SITE_AUTHOR_NAME="Dev Test"
export SITE_KEYWORDS="Test,Dev,Local"

# Génération du site
swift run HyweeneSiteGeneratorBin
```

## Notes

- Toutes les variables sont optionnelles
- Les valeurs par défaut sont utilisées si les variables ne sont pas définies
- Les paths sont composés automatiquement à partir des chemins de base
- Les couleurs (Gruvbox) ne sont pas configurables via environnement
