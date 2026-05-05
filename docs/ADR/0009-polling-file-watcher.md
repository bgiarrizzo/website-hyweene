---
title: "Snapshot polling file watcher (dev mode)"
filename: "0009-polling-file-watcher.md"
description: "File change detection in dev mode using timestamped snapshot polling."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0009 — Snapshot polling file watcher (dev mode)

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

`hyweene dev` must detect changes in `content/` and `generator/Templates/` to trigger
automatic rebuilds. Multiple change-detection mechanisms exist on macOS and Linux.

The main constraint is **portability**: the project must work on both macOS and Linux
(including CI environments).

## Decision

We decided to implement a **snapshot polling watcher** in
`Runtime/DirectoryWatcher.swift`:

- At each interval (500 ms by default), `DirectoryWatcher` recursively scans watched
  directories and builds a `[path: modificationDate]` dictionary snapshot.
- If the current snapshot differs from the previous one, the `onChange` callback is triggered.
- Polling is implemented with `Task.sleep(for:)` (Swift concurrency), avoiding blocked system
  threads.
- Hidden files and packages are ignored via `FileManager.enumerator` options.

## Consequences

### Advantages

- **Cross-platform**: behaves the same on macOS and Linux without conditional OS-specific code.
- Simple to understand, debug, and test.
- No dependency on `FSEvents` (macOS-only) or `inotify` (Linux-only).
- Debounce duration is configurable at initialization.

### Drawbacks / Risks

- Detection latency is bounded by polling interval (500 ms by default): less reactive than
  event-driven APIs.
- Light but non-zero CPU usage (filesystem scan every 500 ms).
- On very large trees, snapshotting can become expensive.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| `FSEvents` (macOS) | Available only on macOS; requires conditional Linux implementation. |
| `kqueue` / `inotify` | Low-level OS-specific APIs with high implementation complexity. |
| `DispatchSource.makeFileSystemObjectSource` | macOS/Darwin only. |
| Third-party library (e.g., `FileWatch`) | Adds external dependency for a dev-only feature. |
