---
title: "ADR 0018: Homepage composition decoupled from runtime generators"
filename: "0018-homepage-composition-decoupled-from-runtime-generators.md"
description: "Move homepage composition behind a Domain use case and stop depending on runtime generator instances."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
---

# ADR 0018: Homepage composition decoupled from runtime generators

Status: Accepted

## Context

After the blog, links, and pages pipelines were migrated behind Domain use cases, homepage generation still depended directly on mutable runtime generator instances:

- `HomepageGenerator` received `BlogGenerator` and `LinksGenerator`
- it pulled `posts` and `links` from those runtime objects at render time

That kept a runtime-to-runtime dependency in the middle of the build pipeline and prevented homepage composition from being expressed as a pure business capability over already-generated Domain entities.

## Decision

Homepage composition is moved behind a Domain use case:

- Domain:
  - `GenerateHomepageUseCase`
- Runtime:
  - `HomepageGenerator` now accepts `[BlogPostEntity]` and `[LinkItemEntity]`
  - `HomepageGenerator` wires `FileRepository` and `TemplateRepository` implementations, then delegates rendering to `GenerateHomepageUseCase`
- Build orchestration:
  - `SiteBuildRuntime` passes `blogGenerator.posts` and `linksGenerator.links` as explicit inputs when creating the homepage generator

The homepage use case keeps the existing output contract:

- writes `index.html`
- renders `homepage.stencil`
- limits homepage content to the latest 10 blog posts and latest 10 links

## Consequences

Positive:

- Homepage composition no longer depends on mutable runtime generator objects.
- The build pipeline expresses dependencies through explicit data flow instead of object coupling.
- Homepage rendering is unit-testable through repository mocks.

Trade-offs:

- `HomepageGenerator` still exists as a runtime adapter, so there is one extra layer between the build runtime and the use case.
- The build runtime still sequences homepage generation after independent generators, which is correct but remains an orchestration concern outside the Domain layer.

## Alternatives Considered

### Keep homepage logic in `HomepageGenerator`

Rejected because it preserves runtime coupling and leaves homepage composition outside the migration path.

### Merge homepage logic directly into `SiteBuildRuntime`

Rejected because it would remove coupling at the cost of bypassing the use-case boundary.
