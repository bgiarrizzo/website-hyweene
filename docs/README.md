---
title: "Documentation index"
filename: "README.md"
description: "Documentation entry point: what to read depending on the task, sources of truth."
creation_date: 2026-04-27
update_date: 2026-04-28
category: meta
author: Bruno Giarrizzo
---

# Documentation

## Start here (agent)
1. Read `AGENTS.md` (global engineering rules).
2. Read `docs/APP.md` (product rules, glossary, non-goals).
3. Read `docs/ARCHITECTURE.md` (folder layout, layer rules, data flow).
4. Check ADRs in `docs/ADR/` for constraints and past decisions.

## What to read depending on the task

### Add or change a screen / UI component
- `docs/ARCHITECTURE.md` → Canonical folder layout, Views, ViewModel rules
- `docs/FEATURES.md` → find the feature domain / expected behavior
- ADRs: check if there are UI/architecture constraints

### Modify game rules / solver / domain logic
- `docs/APP.md` → product behavior and user-facing rules (source of truth)
- `docs/ARCHITECTURE.md` → architecture boundaries and build pipeline
- `docs/ADR/` → core architecture and tooling decisions

### Refactor / dependency changes
- `docs/STACK.md`
- `docs/ADR/` → decisions about libraries and patterns

### Setup / run / test
- `docs/SETUP.md`
- `AGENTS.md` → testing & PR instructions

## Sources of truth
- Product behavior and feature rules: `docs/APP.md`
- Architecture and code organization rules: `docs/ARCHITECTURE.md`
- Historical technical decisions and constraints: `docs/ADR/`
- Global engineering practices: `AGENTS.md`