---
title: "Ink as the Markdown parser"
filename: "0005-ink-markdown-parser.md"
description: "Decision to use Ink for parsing the site's Markdown content."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0005 — Ink as the Markdown parser

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

All site content (blog posts, links, pages, learning modules) is written in Markdown with
YAML frontmatter. The generator needs a Markdown parser able to convert Markdown into HTML.

Selection criteria are: native Swift library, zero system dependencies, lightweight footprint,
and customizable handling of code blocks (Prism.js integration).

## Decision

We decided to use **Ink** (`JohnSundell/Ink`) to convert Markdown to HTML.
`MarkdownParser` (`Parsers/MarkdownParser.swift`) wraps Ink and applies post-processing via
`PrismCodeProcessor` to enrich code blocks with the CSS classes expected by Prism.js.

## Consequences

### Advantages

- Ink is a pure Swift library with no native dependencies (no libcmark, no system deps).
- Simple API: `MarkdownParser().html(from: markdownString)`.
- Extensible via modifiers (`Modifier`) to customize rendering of specific elements.
- Cross-platform compatibility on macOS/Linux with no special setup.

### Drawbacks / Risks

- Ink does not implement the full CommonMark spec (e.g., some GFM extensions are unsupported).
- The project is less actively maintained than cmark or goldmark.
- Markdown tables have partial support.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| cmark (C) | Requires a Swift wrapper and a system dependency. |
| swift-markdown (Apple) | AST-oriented API; more complex for straightforward HTML rendering. |
| CommonMark.swift | Lower community traction than Ink for Swift projects. |
| Down | cmark wrapper with transitive C dependency. |
