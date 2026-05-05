---
title: "swift-argument-parser for CLI"
filename: "0011-swift-argument-parser.md"
description: "Use of swift-argument-parser to define CLI subcommands and options."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0011 — swift-argument-parser for CLI

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

The `hyweene` binary exposes several subcommands (`build`, `dev`, `quick-add-link`,
`check-dead-links`) with typed options (`--host`, `--port`, `--comment`, `--path`).
Manual parsing of `CommandLine.arguments` is verbose, error-prone, and hard to test.

## Decision

We decided to use **`swift-argument-parser`** (`apple/swift-argument-parser`) to define
subcommands via `AsyncParsableCommand` structs. Each subcommand declares options with
`@Option` and `@Argument`, and implements `run() async throws`.

The root command `HyweeneCLIApp` is defined in `HyweeneSiteGenerator/Runtime/CLIApp.swift`
(testable library). The `hyweene` executable only calls `HyweeneCLIApp.main()`.

## Consequences

### Advantages

- Typed argument parsing with automatic validation (e.g., `--port` is an `Int` in the 1–65535
  range via `validate()`).
- Automatic `--help` generation for each command and subcommand.
- Standardized usage error handling (error message + contextual help).
- Official Apple library, well maintained, compatible with Swift 6.
- `AsyncParsableCommand` natively supports `async throws`, aligned with the async runtime.

### Drawbacks / Risks

- External dependency (even if it is official Apple tooling).
- Slight over-engineering for a CLI with only 4 subcommands, but readability and testability
  justify the choice.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Manual `CommandLine.arguments` parsing | Verbose, fragile, no automatic help. |
| Commander (older Swift libs) | Unmaintained or less integrated with Swift 6 / `async`. |
| Custom argument parser | Unnecessary when a mature official solution exists. |
