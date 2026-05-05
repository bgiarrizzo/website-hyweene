---
title: "YAML frontmatter for content metadata"
filename: "0006-yaml-frontmatter.md"
description: "Decision to use YAML format for metadata at the top of each Markdown file."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0006 — YAML frontmatter for content metadata

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

Each content file (blog post, link, page, learning module) includes structured metadata:
title, date, categories, tags, description, etc. This metadata must be readable by the
generator and easy to edit manually.

## Decision

We decided to use **YAML frontmatter**: a YAML block delimited by `---` at the top of each
Markdown file, parsed with **Yams** (`jpsim/Yams`). `MarkdownParser` extracts the frontmatter
using a regular expression, parses it with Yams, and returns the Markdown body separately.

## Consequences

### Advantages

- De facto standard format for static site generators (Hugo, Jekyll, Eleventy...):
  convention recognized by editors and external tooling.
- YAML is readable and editable without specific tooling.
- Yams is a native Swift library, well maintained, with no system dependencies.
- Frontmatter/body separation simplifies parsing into two clear sections.

### Drawbacks / Risks

- YAML is indentation-sensitive and can produce silent errors (the parser logs a warning but
  continues with an empty dictionary).
- Typing is dynamic (`[String: Any]`): missing-key errors are only detected at runtime.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| TOML frontmatter | Less standard in the SSG ecosystem; no Swift library as mature as Yams. |
| JSON frontmatter | Verbose and uncomfortable to write manually. |
| Filename as sole metadata source | Insufficient for title, tags, categories, description, etc. |
