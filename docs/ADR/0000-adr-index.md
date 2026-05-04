---
title: "ADR Index — Make 67"
filename: "0000-adr-index.md"
description: "Index of all Architecture Decision Records (ADRs) for the project."
creation_date: 2026-04-27
update_date: 2026-04-28
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
|---|---|---|---|
| 0000 | [0000-adr-index.md](0000-adr-index.md) | Index (this file) | — |
| 0001 | [0001-adr-template.md](0001-adr-template.md) | Template ADR | — |
| 0002 | [0002-left-to-right-arithmetic-evaluation.md](0002-left-to-right-arithmetic-evaluation.md) | Strict left-to-right arithmetic evaluation | Accepted |
| 0003 | [0003-mvvm-clean-architecture.md](0003-mvvm-clean-architecture.md) | MVVM + Clean Architecture | Accepted |
| 0004 | [0004-guaranteed-solvable-hand-generation.md](0004-guaranteed-solvable-hand-generation.md) | Guaranteed-solvable hand generation | Accepted |
| 0005 | [0005-swift-testing-over-xctest.md](0005-swift-testing-over-xctest.md) | Swift Testing over XCTest | Accepted |
| 0006 | [0006-observable-macro-over-observable-object.md](0006-observable-macro-over-observable-object.md) | `@Observable` macro over `ObservableObject` | Accepted |
| 0007 | [0007-no-data-persistence.md](0007-no-data-persistence.md) | No data persistence | Accepted |
| 0008 | [0008-canvas-timelineview-confetti-animation.md](0008-canvas-timelineview-confetti-animation.md) | `Canvas` + `TimelineView` for the confetti animation | Accepted |
| 0009 | [0009-sentry-error-monitoring.md](0009-sentry-error-monitoring.md) | Sentry for error monitoring | Accepted |