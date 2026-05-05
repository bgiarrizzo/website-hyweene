---
title: "Swift as the implementation language"
filename: "0002-swift-as-implementation-language.md"
description: "Decision to use Swift as the single language for the static site generator."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0002 — Swift as the implementation language

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

This project generates a personal static site (hyweene.fr). A static site generator is
primarily a command-line tool: it reads Markdown files, transforms them, and writes HTML files.
Many languages are viable for this type of tool (Python, Node.js, Go, Rust, Ruby...).

The personal context of this project is that of a daily iOS developer whose primary tool is
Swift. A secondary goal is to maintain Swift expertise outside of iOS-specific work.

## Decision

We decided to implement the entire generator in **Swift 6**, using Swift Package Manager
as the build system.

## Consequences

### Advantages

- Consistency with the developer's existing ecosystem (daily Swift on iOS).
- Swift 6 + strict concurrency enables safe and expressive modeling of a parallel build pipeline.
- Single-language project: no Python/Shell/JS mix.
- Strong typing and native performance comparable to Go or Rust for a CLI tool.
- Business logic is in a library (`HyweeneSiteGenerator`) testable with Swift Testing.

### Drawbacks / Risks

- Swift tooling on Linux is less mature than on macOS (some Foundation APIs are unavailable,
  hence the use of `FoundationNetworking`).
- Compile times are longer than Python or Node.js for a project of this size.
- The Swift ecosystem for site generation is much smaller than Python (Jekyll, Hugo)
  or Node.js (Eleventy, Astro).

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Python      | Already used for helper scripts (`check_dead_links.py`, `quick_add_link.py`) but rejected as the primary language to keep the project aligned with Swift and reduce polyglot surface area. |
| Go          | Excellent for CLIs, but outside the developer's day-to-day ecosystem. |
| Node.js / TypeScript | Rich SSG ecosystem, but heterogeneous with the rest of the Swift stack. |
| Rust        | Great performance, but steeper learning curve and outside project context. |
