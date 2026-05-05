---
title: "Parallel build pipeline with OperationQueue"
filename: "0008-parallel-build-pipeline.md"
description: "Concurrent execution of independent generators via a dedicated OperationQueue."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0008 — Parallel build pipeline with OperationQueue

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

The site contains several independent sections (blog, links, static pages, learning,
resume). Generating each section does not depend on the others. A sequential pipeline leaves
CPU time unused, especially on modern multi-core machines.

Inside each generator, individual items (posts, links, pages) are also independent and can be
rendered in parallel.

## Decision

We decided to use **`OperationQueue`** with a `maxConcurrentOperationCount` based on
the processor count (`ProcessInfo.processInfo.processorCount`) to execute independent operations
in parallel.

The `runConcurrently(operations:)` utility (`Utils/ConcurrentExecutor.swift`) encapsulates this
pattern: it creates a queue, adds `BlockOperation`s, and propagates the first error found by
cancelling remaining operations (`cancelAllOperations()`).

The build pipeline is organized in two ordered phases:
1. **Parallel phase**: `BlogGenerator`, `LinksGenerator`, `PagesGenerator`,
   `LearnGenerator`, `ResumeGenerator` — executed in parallel via `runConcurrently`.
2. **Sequential phase**: `HomepageGenerator` (depends on blog and link outputs),
   `SitemapGenerator` — executed after the parallel phase.

## Consequences

### Advantages

- Significant build-time reduction on multi-core machines.
- The *fail-fast* policy (first failure cancels all) prevents partially valid site outputs.
- `runConcurrently` is reusable in individual generators to parallelize item rendering.

### Drawbacks / Risks

- `OperationQueue` is a synchronous GCD/Foundation API, not native Swift concurrency
  (`async`/`await`). This trade-off is intentional: generators are synchronous `throws`
  functions, and wrapping each write in a `Task` would add unnecessary complexity.
- Shared mutable state between parallel operations must be avoided or protected; generators
  are designed to write to distinct filesystem paths.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| `async let` / `TaskGroup` (Swift concurrency) | Generators are synchronous (`throws`, not `async throws`); migration would add complexity with limited short-term gain. |
| `DispatchGroup` + `DispatchQueue.concurrentPerform` | Lower-level and less readable than `OperationQueue` for this use case. |
| Sequential pipeline | Underutilizes CPU and increases build time. |
