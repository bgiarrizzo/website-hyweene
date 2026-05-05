# Configuration via Environment Variables

The site generator supports environment-variable-based configuration, similar in spirit to Pydantic in Python.

## How It Works

All configuration properties can be overridden via environment variables. If a variable is not set, the default value is used.

## Available Variables

### URL Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SITE_SCHEME` | `https` | Site protocol |
| `SITE_SHORT_URL` | `hyweene.fr` | Short site URL |
| `SITE_LONG_URL` | `www.hyweene.fr` | Full site URL |
| `SITE_BASE_URL` | `https://www.hyweene.fr` | Full base URL |

### Path Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SITE_RELEASES_PATH` | `releases` | Releases folder |
| `SITE_CURRENT_RELEASE_PATH` | `current` | Symlink name for the current release |
| `SITE_CONTENT_PATH` | `content` | Content root folder |
| `SITE_MEDIA_PATH` | `content/media` | Media folder |
| `SITE_STATIC_PATH` | `content/static` | Static files folder |
| `SITE_TEMPLATE_PATH` | `generator/Templates` | Templates folder |
| `SITE_TEXT_CONTENT_PATH` | `content/text` | Text content folder |
| `SITE_BLOG_PATH` | `content/text/blog` | Blog posts folder |
| `SITE_LINKS_PATH` | `content/text/links` | Links folder |
| `SITE_PAGES_PATH` | `content/text/pages` | Pages folder |
| `SITE_RESUME_PATH` | `content/text/resume` | Resume folder |
| `SITE_LEARN_PATH` | `content/text/learn` | Learning modules folder |

### Author Information

| Variable | Default | Description |
|----------|---------|-------------|
| `SITE_AUTHOR_NAME` | `Bruno Giarrizzo` | Author name |
| `SITE_AUTHOR_FULL` | `Bruno 'Hyweene' Giarrizzo` | Full author name |
| `SITE_GITHUB_LINK` | `https://github.com/bgiarrizzo/` | GitHub link |
| `SITE_LINKEDIN_LINK` | `https://www.linkedin.com/in/bruno-giarrizzo/` | LinkedIn link |

### Site Metadata

| Variable | Default | Description |
|----------|---------|-------------|
| `SITE_DESCRIPTION` | `Linuxien, Developpeur Python, Swift et DevOps` | Site description |
| `SITE_KEYWORDS` | `Bruno,Giarrizzo,...` | Keywords (comma-separated) |
| `SITE_LANGUAGE` | `fr-FR` | Site language |
| `SITE_LOCALE` | `fr_FR.UTF-8` | Site locale |

## Usage

### 1. Via .env file

Copy `.env.example` to `.env` and customize values:

```bash
cp .env.example .env
# Edit .env with your values
```

Then source the file before running the generator:

```bash
export $(cat .env | xargs)
swift run hyweene build
```

### 2. Via direct export

```bash
export SITE_AUTHOR_NAME="My Name"
export SITE_SHORT_URL="mysite.com"
export SITE_KEYWORDS="Keyword1,Keyword2,Keyword3"
swift run hyweene build
```

### 3. Via one-line command

```bash
SITE_AUTHOR_NAME="My Name" swift run hyweene build
```

### 4. Via mise

Use `mise` tasks with inline environment variables:

```bash
SITE_BASE_URL="http://localhost:8000" mise run build
SITE_BASE_URL="https://www.hyweene.fr" mise run build
```

## Value Format

### Strings
Simple values: `SITE_AUTHOR_NAME="My Name"`

### Arrays
Comma-separated values: `SITE_KEYWORDS="Keyword1,Keyword2,Keyword3"`

Spaces around commas are automatically trimmed.

## Tests

Unit tests verify that:
- Default values are correct
- Environment variables can be read
- Data types are correct (strings, arrays)

Run tests with:

```bash
swift test
```

## Complete Example

```bash
# Local development configuration
export SITE_SCHEME="http"
export SITE_SHORT_URL="localhost:8000"
export SITE_BASE_URL="http://localhost:8000"
export SITE_AUTHOR_NAME="Dev Test"
export SITE_KEYWORDS="Test,Dev,Local"

# Site generation
swift run hyweene build

# Development mode
swift run hyweene dev --host 0.0.0.0 --port 1234
```

## Notes

- All variables are optional
- Defaults are used when variables are not defined
- Paths are automatically composed from base paths
- Colors (Gruvbox) are not configurable via environment variables
