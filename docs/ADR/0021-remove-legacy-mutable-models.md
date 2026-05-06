---
title: "ADR 0021: Remove legacy mutable Models layer after generator migrations"
filename: "0021-remove-legacy-mutable-models.md"
description: "Delete obsolete mutable model classes once all runtime generators depend on Domain entities and use cases."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
---

# ADR 0021: Remove legacy mutable Models layer after generator migrations

Status: Accepted

## Context

After migrating blog, links, pages, learn, homepage, and resume generation behind Domain use cases and Data repositories, the old mutable model files in `Sources/HyweeneSiteGenerator/Models/` became unused:

- `BlogPost.swift`
- `LinkItem.swift`
- `Page.swift`
- `LearnModule.swift`
- `Resume.swift`

Keeping those files created duplicated business behavior, encouraged accidental re-coupling to runtime logic, and increased maintenance cost.

## Decision

Remove the obsolete mutable model files and keep only the migrated architecture:

- Domain entities and use cases as the business source of truth
- Data DTOs/mappers/repositories for file-system parsing and adaptation
- Runtime generators as thin orchestration adapters

One compatibility value object (`BlogPostCategory`) is retained as a dedicated Domain entity because active use cases and tests depend on it.

## Consequences

Positive:

- Removes duplicate implementations of parsing, sorting, and template mapping behavior.
- Reduces risk of architectural regression back to runtime-heavy mutable models.
- Clarifies the intended dependency flow for all generation pipelines.

Trade-offs:

- Historical references to legacy types in older ADRs now represent migration history, not current code structure.
- Any future change that intentionally needs mutable runtime models must be introduced explicitly and justified rather than reused from leftovers.

## Alternatives Considered

### Keep legacy models for fallback

Rejected because there is no active runtime caller left and fallback code would be untested drift.

### Deprecate files but keep them in source tree

Rejected because deprecation markers do not prevent accidental usage and still impose maintenance overhead.