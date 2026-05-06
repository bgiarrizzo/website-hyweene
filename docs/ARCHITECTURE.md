# ARCHITECTURE

## Overview

The generator is currently organized into two runtime layers:

- `HyweeneSiteGenerator` library (testable business logic)
- `hyweene` executable (CLI routing via `swift-argument-parser`)

CLI subcommands (`build`, `dev`, `quick-add-link`, `check-dead-links`) are defined in the library (`Runtime/CLIApp.swift`) so they remain testable, while the executable only exposes the `@main` entry point.

## Target Architecture (AGENTS alignment)

The target is Clean Architecture adapted for a CLI static site generator:

- `Runtime/App`:
   - CLI argument parsing and command entry points
   - command-to-use-case orchestration
   - user-facing error mapping
- `Domain`:
   - immutable entities
   - one use case per business capability (`execute()`)
   - repository protocols only
- `Data`:
   - repository implementations
   - DTOs and mappers
   - adapters to filesystem, template engine, and network
- `Core`:
   - shared utilities, parsers, and infrastructure helpers

Dependency direction:

- `Runtime/App -> Domain <- Data`

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

This pipeline behavior is a compatibility contract and must remain stable during refactors.

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

## Migration Strategy

- Introduce Domain use cases and repository protocols before removing legacy classes.
- Keep old and new paths side-by-side when necessary.
- Validate generated output consistency at each migration step.
- Add tests for each migrated type in the mirrored test tree.

## Migration Progress (May 2026)

- Blog pipeline migrated:
   - `GenerateBlogUseCase`
   - `BlogPostEntity`, `BuildBlogResult`
   - `ContentRepository` + file/template adapters
- Links pipeline migrated:
   - `GenerateLinksUseCase`
   - `LinkItemEntity`, `BuildLinksResult`
   - `LinkContentRepository` + file/template adapters
- Pages pipeline migrated:
   - `GeneratePagesUseCase`
   - `PageEntity`, `BuildPagesResult`
   - `PageContentRepository` + file/template adapters
- Learn pipeline migrated:
   - `GenerateLearnUseCase`
   - `LearnModuleEntity`, `LearnModulePageEntity`, `BuildLearnResult`
   - `LearnContentRepository` + filesystem adapter
- Homepage composition migrated:
   - `GenerateHomepageUseCase`
   - runtime input is now `[BlogPostEntity]` + `[LinkItemEntity]`
- Resume pipeline migrated:
   - `GenerateResumeUseCase`
   - `ResumeEntity` aggregate with typed section entities
   - `ResumeContentRepository` + filesystem adapter
- Runtime generators (`BlogGenerator`, `LinksGenerator`, `PagesGenerator`, `LearnGenerator`, `HomepageGenerator`, `ResumeGenerator`) are now orchestration adapters delegating to Domain use cases.
