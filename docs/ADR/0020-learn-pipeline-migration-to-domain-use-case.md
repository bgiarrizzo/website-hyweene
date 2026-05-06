---
title: "ADR 0020: Learn pipeline migration to Domain use case and Data adapters"
filename: "0020-learn-pipeline-migration-to-domain-use-case.md"
description: "Move learning modules generation from legacy mutable models to Domain entities, a repository, and a use case."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
---

# ADR 0020: Learn pipeline migration to Domain use case and Data adapters

Status: Accepted

## Context

The original learning pipeline concentrated module parsing, page parsing, rendering, and file output in runtime-oriented mutable classes:

- `LearnGenerator`
- `LearnModule`
- `LearnModulePage`

That structure mixed discovery, validation, transformation, and rendering concerns, which made the learning pipeline harder to test in isolation and inconsistent with the migration pattern already adopted for blog, links, pages, homepage, and resume.

The legacy implementation also dropped page tags even though the learning page template expects `learn.tags` in its metadata block.

## Decision

The learning modules pipeline is migrated to explicit Domain and Data boundaries:

- Domain:
  - `LearnModuleEntity`
  - `LearnModulePageEntity`
  - `BuildLearnResult`
  - `LearnContentRepository`
  - `GenerateLearnUseCase`
- Data:
  - `LearnModuleDTO`
  - `LearnModulePageDTO`
  - `LearnModuleMapper`
  - `FileSystemLearnContentRepository`
- Runtime:
  - `LearnGenerator` becomes a thin orchestration adapter that wires concrete repositories and delegates to `GenerateLearnUseCase`

Compatibility is preserved by keeping the legacy template dictionary shape for module and page rendering, including nested `module` data on page context.

The new DTO layer normalizes learning page tags from either YAML arrays or comma-separated strings so template metadata receives the tags the content files define.

## Consequences

Positive:

- Learning modules generation is now unit-testable without real filesystem writes or template rendering by default.
- The migration pattern is now consistent across all major content generators except legacy models that remain for compatibility.
- Learning page tags are now explicitly preserved in the generated template context.

Trade-offs:

- A temporary compatibility period existed during migration where both legacy and new paths coexisted.
- The filesystem repository still relies on directory discovery order and then applies ascending `id` sorting at the Domain boundary.

## Alternatives Considered

### Keep the learning pipeline in `LearnGenerator`

Rejected because it preserves architectural coupling and the weakly validated mutable workflow.

### Only patch tags in the legacy models

Rejected because it would fix one behavioral gap without moving the learning pipeline onto the target architecture.