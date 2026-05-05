---
title: "Timestamped releases and `current` symlink"
filename: "0007-timestamped-releases-symlink.md"
description: "Atomic publication strategy using timestamped directories and a `current` symlink."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0007 — Timestamped releases and `current` symlink

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

The generator produces a set of HTML files to be served by an HTTP server.
Two issues arise when updating the site:

1. **Atomicity**: while a new generation is being written, the server must not serve
   a partial state (mix of old/new files).
2. **Rollback**: in case of failure, the previous site must stay available without intervention.

## Decision

We decided to use the following strategy:

- Each build writes files into a unique **timestamped directory**:
  `releases/YYYYMMDDHHMMSS/`.
- At the end of a **successful** build, the `current` symlink is atomically updated
  to point to this new directory.
- The HTTP server (and production server) serves only from `current`.
- A **cleanup** mechanism removes older releases beyond a configurable limit.
- If a build fails (dev mode), `current` keeps pointing to the latest valid release.

## Consequences

### Advantages

- Atomic publication: symlink switch is an atomic filesystem operation.
- Automatic rollback in dev mode: the server keeps serving the stable state.
- Local release history (debugging, comparison).
- No downtime during rebuild.

### Drawbacks / Risks

- Disk usage grows if release cleanup is not configured properly.
- Symlinks can cause issues with some Windows deployment tools.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Direct write to a fixed `public/` folder | Not atomic: during generation, the server serves partially updated files. |
| Copy then `mv` directory | `mv` across filesystems is not atomic; symlink switch is. |
| In-memory-only build | Impossible to serve through a standard static HTTP server. |
