---
title: "Use-case boundary and error strategy"
filename: "0015-use-case-boundary-and-error-strategy.md"
description: "Define use-case execution boundaries and runtime error mapping for CLI commands."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: "Accepted"
---

# 0015 — Use-Case Boundary and Error Strategy

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

As the project migrates to Domain use cases, command handlers need stable boundaries and predictable error behavior. AGENTS.md requires explicit, testable, and maintainable orchestration with clear separation between domain logic and runtime concerns.

## Decision

We decided to adopt these rules:

- Business capabilities are exposed through dedicated use cases with `execute()` methods.
- Runtime/CLI commands orchestrate use cases and map failures to user-facing messages.
- Use cases encapsulate business intent; infrastructure errors are translated at boundaries.
- Use cases can be dependency-injected with callable adapters to improve test determinism.

## Consequences

### Advantages

- Command behavior is easier to test in isolation.
- Domain logic can evolve independently from CLI glue code.
- Error handling becomes clearer and more consistent.

### Drawbacks / Risks

- Additional abstractions increase short-term implementation overhead.
- Inconsistent adoption across features can create mixed patterns during transition.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Keep runtime functions as direct business entry points only | Limits composability and test seam quality during migration. |
| Use only generic `Error` everywhere | Poor diagnostics and weaker boundary contracts. |
