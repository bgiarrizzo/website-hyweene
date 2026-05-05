# ARCHITECTURE

## Overview

The generator is organized into two layers:

- `HyweeneSiteGenerator` library (testable business logic)
- `hyweene` executable (CLI routing via `swift-argument-parser`)

CLI subcommands (`build`, `dev`, `quick-add-link`, `check-dead-links`) are defined in the library (`Runtime/CLIApp.swift`) so they remain testable, while the executable only exposes the `@main` entry point.

## Build Pipeline

1. Copy assets (`content/media`, `content/static`)
2. Run independent generators in parallel:
   - BlogGenerator
   - LinksGenerator
   - PagesGenerator
   - LearnGenerator
   - ResumeGenerator
3. Run dependent generators sequentially:
   - HomepageGenerator (depends on blog + links)
   - SitemapGenerator
4. Publish:
   - update the `current` symlink
   - clean old releases

## Parallelization

Parallelization relies on a dedicated concurrent executor:

- Parallel loops for posts, links, learning modules/pages, and static pages
- Error propagation on first failure
- Cancellation of remaining operations after failure

## Dev Mode

Dev mode combines:

- Initial build
- Minimal local HTTP server (`Network` on Apple platforms, native Swift fallback with POSIX sockets on Linux)
- Snapshot-based file watcher (polling) with 500 ms debounce
- Rebuild when a change is detected

The server keeps serving the latest valid release if a rebuild fails.

## CLI Link Tools

The CLI runtime also includes content maintenance commands:

- `quick-add-link`: fetch remote HTML title + generate a link Markdown file (interactive or non-interactive with `--comment`)
- `check-dead-links`: recursively scan generated HTML + detect external 404 links
