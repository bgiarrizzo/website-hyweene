---
title: "Clean Architecture CLI migration"
filename: "0014-clean-architecture-cli-migration.md"
description: "Adopt a CLI-adapted Clean Architecture migration plan while preserving generated output compatibility."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: "Accepted"
---

# 0014 — Clean Architecture CLI Migration

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

The project is a Swift CLI static site generator. The current implementation is functionally solid but mixes orchestration, domain rules, parsing, and I/O concerns in several places. The engineering directives in AGENTS.md require stronger separation of concerns, explicit testability, and incremental maintainable evolution.

## Decision

We decided to migrate the codebase toward Clean Architecture adapted for CLI:

- Runtime/App: CLI parsing and orchestration
- Domain: immutable entities, use cases, repository protocols
- Data: repository implementations, DTOs, mappers, infrastructure adapters
- Core: shared parsers and utilities

The migration will be incremental. Existing behavior and generated output structure are treated as compatibility constraints.

## Consequences

### Advantages

- Better testability through protocol boundaries and use-case isolation.
- Lower coupling between business rules and infrastructure.
- Safer long-term evolution and clearer ownership of responsibilities.
- Better alignment with AGENTS.md directives.

### Drawbacks / Risks

- Temporary duplication during migration (legacy + new paths).
- More files and abstractions to navigate.
- Risk of regressions if output compatibility checks are incomplete.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Keep current architecture unchanged | Insufficient alignment with AGENTS directives and long-term maintainability goals. |
| Big-bang rewrite | Too risky for a generator with output compatibility constraints. |
