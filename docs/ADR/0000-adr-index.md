---
title: "ADR Index — Hyweene Static Site Generator"
filename: "0000-adr-index.md"
description: "Index of all Architecture Decision Records (ADRs) for the project."
creation_date: 2026-04-27
update_date: 2026-05-06
category: adr
---

# ADR Index

This folder contains Architecture Decision Records (ADRs) for this app.

## ADR format
Each ADR MUST include:
- Status: Proposed | Accepted | Deprecated | Superseded
- Context
- Decision
- Consequences
- Alternatives considered (optional but recommended)

## Naming
- `NNNN-short-kebab-case-title.md`
- NNNN is a zero-padded incremental number starting at 0000.

## List

| # | File | Title | Status |
|---|------|-------|--------|
| 0000 | [0000-adr-index.md](0000-adr-index.md) | Index (this file) | — |
| 0001 | [0001-adr-template.md](0001-adr-template.md) | Template ADR | — |
| 0002 | [0002-swift-as-implementation-language.md](0002-swift-as-implementation-language.md) | Swift as the implementation language | Accepted |
| 0003 | [0003-library-executable-split.md](0003-library-executable-split.md) | Library / executable split | Accepted |
| 0004 | [0004-stencil-template-engine.md](0004-stencil-template-engine.md) | Stencil as the template engine | Accepted |
| 0005 | [0005-ink-markdown-parser.md](0005-ink-markdown-parser.md) | Ink as the Markdown parser | Accepted |
| 0006 | [0006-yaml-frontmatter.md](0006-yaml-frontmatter.md) | YAML frontmatter for content metadata | Accepted |
| 0007 | [0007-timestamped-releases-symlink.md](0007-timestamped-releases-symlink.md) | Timestamped releases and `current` symlink | Accepted |
| 0008 | [0008-parallel-build-pipeline.md](0008-parallel-build-pipeline.md) | Parallel build pipeline with OperationQueue | Accepted |
| 0009 | [0009-polling-file-watcher.md](0009-polling-file-watcher.md) | Snapshot polling file watcher (dev mode) | Accepted |
| 0010 | [0010-local-http-server-network-posix-fallback.md](0010-local-http-server-network-posix-fallback.md) | Local HTTP server: Network.framework with POSIX fallback | Accepted |
| 0011 | [0011-swift-argument-parser.md](0011-swift-argument-parser.md) | swift-argument-parser for CLI | Accepted |
| 0012 | [0012-mise-task-runner.md](0012-mise-task-runner.md) | mise as project task runner | Accepted |
| 0013 | [0013-environment-variable-configuration.md](0013-environment-variable-configuration.md) | Environment-variable-based configuration | Accepted |