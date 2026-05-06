# Hyweene Static Site Generator

Swift static site generator for hyweene.fr.

This repository follows the engineering directives in `AGENTS.md`. The file is normative and code/docs are aligned to it.

## CLI Commands

The `hyweene` binary exposes four explicit commands:

CLI parsing is handled by `swift-argument-parser` (typed subcommands and options).

```bash
hyweene build
hyweene dev
hyweene dev --host 0.0.0.0 --port 1234
hyweene quick-add-link https://example.com
hyweene quick-add-link https://example.com --comment "Great read"
hyweene check-dead-links --path ./current
```

Behavior:
- `build`: generates the site once, updates the `current` symlink, and cleans old releases.
- `dev`: runs an initial build, starts a local HTTP server, and automatically rebuilds when files change.
- `dev` defaults: host `0.0.0.0`, port `8000`.
- `quick-add-link`: fetches a page title from a URL and automatically creates a Markdown file in `content/text/links`.
    - interactive mode: prompts for a comment
    - non-interactive mode: `--comment "..."`
- `check-dead-links`: scans generated HTML files and lists external links returning 404 (JSON output).

## Features

- Parsing Markdown + frontmatter YAML
- Templates Stencil
- Generation of blog, links, pages, resume, and learning sections
- RSS + sitemaps
- Parallel build:
    - independent generators in parallel
    - blog posts in parallel
    - links in parallel
    - learning modules/pages in parallel
    - static pages in parallel
- Development mode with file watching + local server

## Usage via mise

```bash
mise run install
mise run build
mise run dev
mise run test
```

## Direct Usage

```bash
cd generator
swift build

# One-time build
./.build/debug/hyweene build

# Dev mode
./.build/debug/hyweene dev --host 0.0.0.0 --port 1234

# Quick-add a link
./.build/debug/hyweene quick-add-link https://example.com
./.build/debug/hyweene quick-add-link https://example.com --comment "Great read"

# Check dead links
./.build/debug/hyweene check-dead-links --path ./current
```

## Architecture Direction

- Runtime entry points remain in CLI commands.
- Business logic is being migrated toward Domain Use Cases and repository boundaries.
- Data access and rendering adapters remain isolated from Domain rules.
- Migration is incremental to keep generated output behavior stable.

Current migration status:
- `BlogGenerator` delegates to `GenerateBlogUseCase` (Domain + Data adapters).
- `LinksGenerator` delegates to `GenerateLinksUseCase` (Domain + Data adapters).
- `PagesGenerator` delegates to `GeneratePagesUseCase` (Domain + Data adapters).
- `LearnGenerator` delegates to `GenerateLearnUseCase` (Domain + Data adapters).
- `HomepageGenerator` delegates to `GenerateHomepageUseCase` and consumes Domain entities directly.
- `ResumeGenerator` delegates to `GenerateResumeUseCase` (Domain aggregate + Data repository).

## Tests

```bash
cd generator
swift test
```

## Compatibility

- Swift 6+
- macOS 15+