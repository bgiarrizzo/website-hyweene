---
title: "Stencil as the template engine"
filename: "0004-stencil-template-engine.md"
description: "Decision to use Stencil (Jinja2-like) for HTML template rendering."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0004 — Stencil as the template engine

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

The generator must produce HTML files from structured data (posts, links, pages...). Two
approaches are possible: raw Swift string interpolation, or a dedicated template engine with
separate `.stencil` files.

Separating Swift code and HTML markup is a key maintainability goal for the project.

## Decision

We decided to use **Stencil** (`stencilproject/Stencil`) as the template engine.
HTML templates are `.stencil` files in `generator/Templates/`, organized by section
(blog, links, pages...). Rendering is done through `TemplateEngine`, a wrapper over
`Stencil.Environment`.

Custom filters are registered in `TemplateEngine` for project-specific needs
(`is_outdated`, `capitalize`, `join`).

## Consequences

### Advantages

- Familiar and readable Jinja2-like syntax (`{% for %}`, `{% if %}`, `{{ variable }}`).
- Templates are plain text files independent of Swift code: editable without recompilation.
- Dev mode can rebuild the site when a template changes, without restarting the binary.
- Stencil is a native Swift library, with no JavaScript or Python runtime dependency.
- Extensible: add custom filters/tags via `Stencil.Extension`.

### Drawbacks / Risks

- Stencil is less feature-rich than Jinja2 (no macros, limited template inheritance).
- Dynamically typed context: template errors are only detected at runtime.
- Stencil maintenance is less active than some alternatives.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Swift interpolation (`String(format:...)`) | Mixes code and markup; hard to maintain for full HTML pages. |
| Leaf (Vapor) | Depends on Vapor; too heavy for a standalone CLI tool. |
| Mustache | Less expressive (no native conditional logic). |
| GRMustache.swift | Archived and unmaintained project. |
