---
title: "Local HTTP server: Network.framework with POSIX fallback"
filename: "0010-local-http-server-network-posix-fallback.md"
description: "Minimal static HTTP server for dev mode, based on Network.framework with POSIX socket fallback for Linux."
creation_date: 2026-05-06
update_date: 2026-05-06
category: adr
status: Accepted
---

# 0010 — Local HTTP server: Network.framework with POSIX fallback

- **Status:** Accepted
- **Date:** 2026-05-06

## Context

`hyweene dev` needs a local HTTP server to serve generated HTML files.
This server is intentionally minimal: it only serves static files from a root directory.

The main constraint is the same as for the watcher: **macOS/Linux portability**.
`Network.framework` is available on macOS/Darwin but not on Linux.

## Decision

We decided to implement `LocalHTTPServer` (`Runtime/LocalHTTPServer.swift`) in two
code paths selected through conditional compilation:

- **macOS / Darwin**: uses `Network.framework` (`NWListener`, `NWConnection`) for a
  modern asynchronous implementation.
- **Linux (fallback)**: uses raw POSIX sockets (`socket`, `bind`, `listen`, `accept`)
  via `Glibc`, with a `DispatchQueue` to accept concurrent connections.

Both paths serve static files over HTTP/1.0 with `Content-Type` detection based on file
extension, and return `index.html` for paths ending in `/`.

## Consequences

### Advantages

- No external dependency for the development server.
- Works on macOS and Linux without additional setup.
- `Network.framework` implementation benefits from Apple-optimized networking I/O.
- Lightweight: only features needed for dev mode are implemented.

### Drawbacks / Risks

- Two implementations to maintain (`#if canImport(Network)`).
- POSIX fallback still uses `DispatchQueue` (GCD) instead of pure Swift concurrency.
- This server is strictly for local development, not production.

## Alternatives Considered

| Alternative | Reason Rejected |
|-------------|-----------------|
| Vapor / Hummingbird | Too heavy for a minimal development server; introduces many dependencies. |
| `python3 -m http.server` (invoked as subprocess) | Adds Python dependency; less integrated into Swift build workflow. |
| `swift-nio` | Better suited for production servers; over-engineered for dev-only usage. |
| macOS-only server (Network.framework) | Excludes Linux development and Linux CI. |
