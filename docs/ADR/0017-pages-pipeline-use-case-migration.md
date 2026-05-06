---
title: "ADR 0017: Pages pipeline migration to Domain use case and Data adapters"
filename: "0017-pages-pipeline-use-case-migration.md"
description: "Migrate static pages generation from legacy generator/model code to Domain and Data boundaries."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
---

# ADR 0017: Pages pipeline migration to Domain use case and Data adapters

Status: Accepted

## Context

The original pages pipeline concentrated file parsing, mutable model state, rendering, and file output inside runtime-oriented types:

- `PagesGenerator` discovered page files, loaded models, rendered pages, and wrote the sitemap.
- `Page` parsed Markdown frontmatter, held mutable state, produced template dictionaries, and wrote its own output file.

This structure did not match the project target architecture and made the business flow harder to test independently of the filesystem and template engine.

## Decision

The pages generation flow is migrated to explicit Domain and Data boundaries:

- Domain:
  - `PageEntity`
  - `BuildPagesResult`
  - `PageContentRepository`
  - `GeneratePagesUseCase`
- Data:
  - `PageDTO`
  - `PageMapper`
  - `FileSystemPageContentRepository`
  - existing `TemplateRepository` and `FileRepository` adapters reused for rendering and writes
- Runtime:
  - `PagesGenerator` becomes a thin orchestration adapter that wires concrete repositories and delegates to `GeneratePagesUseCase`

Compatibility is preserved by keeping the template dictionary shape identical to the legacy `Page.toDictionary()` output and by preserving the empty-permalink behavior that writes the homepage to `index.html`.

## Consequences

Positive:

- Static pages generation is now unit-testable without using real file writes or template rendering by default.
- The migration pattern is now consistent across blog, links, and pages.
- Runtime code is reduced to dependency wiring and state exposure.

Trade-offs:

- A temporary compatibility period existed during migration where both legacy and new paths coexisted.
- The repository currently preserves filesystem discovery order rather than introducing additional sorting semantics.

## Alternatives Considered

### Keep pages logic inside `PagesGenerator`

Rejected because it preserves the old architectural coupling.

### Migrate homepage orchestration in the same tranche

Deferred to keep the change set focused and reduce regression risk.
