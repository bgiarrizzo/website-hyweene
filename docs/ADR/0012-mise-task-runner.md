---
title: "mise as project task runner"
filename: "0012-mise-task-runner.md"
description: "Use of mise (mise.toml) to orchestrate project development tasks."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0012 — mise as project task runner

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

The project requires multiple recurring tasks: installing the binary, building the site,
running dev mode, executing tests, serving the site. These tasks should be accessible in a
uniform way so developers (and CI) do not need to remember exact commands.

## Decision

We decided to use **`mise`** (`mise.toml`) as the project task runner. Tasks
(`install`, `build`, `dev`, `test`, `serve`, `quick_add_link`) are defined in `mise.toml`
at the repository root. `mise` also manages tool versions for linting (`swiftformat`,
`swiftlint`).

## Consequences

### Advantages

- Single interface for all tasks: `mise run <task>`.
- Task dependency declaration via `depends` (e.g., `build` depends on `install`).
- Tool version management (`swiftformat`, `swiftlint`) declared in `[tools]`:
  reproducibility guaranteed.
- `mise.toml` is readable and self-documented (`description` per task).
- Compatible with macOS and Linux.

### Drawbacks / Risks

- `mise` is an additional tool to install (`brew install mise` or equivalent).
- Developers unfamiliar with `mise` must learn it (small learning curve).

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| `Makefile` | Portable, but older syntax and more complex task dependency management. |
| Shell scripts (`scripts/`) | No tool version management and no native task dependency model. |
| `just` (justfile) | Similar to `mise`, but without integrated tool version management. |
| `npm scripts` (package.json) | Not relevant for a Swift project without Node.js. |
