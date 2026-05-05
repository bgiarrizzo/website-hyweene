---
title: "Library / executable split"
filename: "0003-library-executable-split.md"
description: "Organization of the Swift package into a testable library and a minimal executable."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0003 — Library / executable split

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

A standard Swift executable (`@main` or `CommandLine`) cannot be imported by a test target.
If all logic lives in the executable, unit tests are impossible without relying on integration
tests (invoking the binary).

## Decision

We decided to split the Swift package into two distinct targets:

- **`HyweeneSiteGenerator`** (`.library`): contains all business logic — generators,
  parsers, models, runtime, utilities. This is the target covered by unit tests.
- **`hyweene`** (`.executableTarget`): minimal `@main` entry point. It depends on
  `HyweeneSiteGenerator` and `swift-argument-parser`, and only exposes the root command
  `HyweeneCLIApp`. It contains no standalone logic.

CLI subcommands (`build`, `dev`, `quick-add-link`, `check-dead-links`) are defined in
`HyweeneSiteGenerator/Runtime/CLIApp.swift` so they remain testable.

## Consequences

### Advantages

- All business logic is covered by Swift Testing unit tests.
- The executable target stays trivial (~5 lines) and does not need dedicated tests.
- The library can eventually be reused or published independently.
- Clear separation between CLI orchestration and generation logic.

### Drawbacks / Risks

- Slight additional complexity in `Package.swift` (two targets instead of one).
- `AsyncParsableCommand` subcommands must be `public` to be accessible from the executable.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Everything in the executable | Makes unit testing impossible without invoking the binary. |
| Executable + multiple feature libraries | Over-engineering for a solo project of this size. |
