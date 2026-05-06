---
title: "ADR 0016: Links pipeline migration to Domain use case and Data adapters"
filename: "0016-links-pipeline-use-case-migration.md"
description: "Migrate links generation out of the legacy generator/model workflow into Domain and Data boundaries."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
---

# ADR 0016: Links pipeline migration to Domain use case and Data adapters

Status: Accepted

## Context

The original links pipeline concentrated multiple responsibilities in two runtime-oriented types:

- `LinksGenerator` loaded Markdown files, grouped content, rendered templates, and wrote output files.
- `LinkItem` parsed raw Markdown frontmatter, held mutable state, transformed itself to template dictionaries, and wrote rendered pages.

That structure made the runtime path harder to test in isolation and did not align with the target Clean Architecture defined for this repository.

## Decision

The links generation flow is migrated to explicit Domain and Data boundaries:

- Domain:
  - `LinkItemEntity`
  - `BuildLinksResult`
  - `LinkContentRepository`
  - `GenerateLinksUseCase`
- Data:
  - `LinkItemDTO`
  - `LinkItemMapper`
  - `FileSystemLinkContentRepository`
  - existing template/file adapters reused through `TemplateRepository` and `FileRepository`
- Runtime:
  - `LinksGenerator` becomes a thin orchestration adapter that wires concrete repositories and delegates to `GenerateLinksUseCase`

Compatibility is preserved by keeping the runtime-visible `links` collection on `LinksGenerator`, now backed by `[LinkItemEntity]`, and by matching the legacy template dictionary shape in `LinkItemEntity.toDictionary()`.

## Consequences

Positive:

- Links generation logic becomes unit-testable without the filesystem or template engine by default.
- Repository boundaries now match the blog pipeline migration and create a repeatable pattern for remaining generators.
- Homepage integration remains stable because template context compatibility is preserved.

Trade-offs:

- A temporary compatibility period existed during migration where both legacy and new paths coexisted.
- The full suite can still be memory-intensive in this environment, so focused validation is currently more reliable than one monolithic run.

## Alternatives Considered

### Keep `LinksGenerator` and only add more tests

Rejected because it would improve coverage without fixing the architectural boundary issues.

### Rewrite `HomepageGenerator` at the same time

Deferred to keep the migration incremental and reduce regression risk.
