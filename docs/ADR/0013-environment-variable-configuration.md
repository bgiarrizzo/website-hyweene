---
title: "Environment-variable-based configuration"
filename: "0013-environment-variable-configuration.md"
description: "Generator paths and settings are configurable through environment variables with defaults."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0013 — Environment-variable-based configuration

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

The generator needs many paths (content, templates, releases, media) and site settings
(base URL, author, description). These values vary by execution environment (local, CI,
deployment server) and by user when the project is reused.

## Decision

We decided that **all configuration is centralized in `Config.swift`** as static properties,
each read from an **environment variable** with a sensible **default value**.
The private `env(_:default:)` helper in `Config` wraps
`ProcessInfo.processInfo.environment`.

Examples: `SITE_BASE_URL`, `SITE_RELEASES_PATH`, `SITE_CONTENT_PATH`, `SITE_AUTHOR_NAME`, etc.

The generator automatically resolves the project root (`resolveProjectRootPath()`) by looking
for `content` and `generator` folders from the current working directory, allowing `hyweene`
to be run from either repository root or the `generator` subfolder.

## Consequences

### Advantages

- **No mandatory config file**: the generator works out of the box with defaults for hyweene.fr.
- Easily overridable via environment variables for CI, deployment, or forks.
- No secrets hardcoded in source (sensitive values can be injected).
- `Config` is a static-value struct: testable and importable in tests.

### Drawbacks / Risks

- No startup validation of values (an invalid path fails later when used).
- Automatic root discovery (`resolveProjectRootPath`) can be surprising when the binary
  is invoked from an arbitrary directory.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| JSON/YAML config file | Adds startup reading/parsing step; more complexity with little benefit for this project. |
| CLI arguments for every path | Verbose in daily usage; defaults cover most cases. |
| Hardcoded compile-time constants | Prevents easy reuse and adaptation without recompilation. |
