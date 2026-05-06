# APP

## Purpose

This project generates a personal static site (hyweene.fr) from Markdown/YAML content and Stencil templates.

It is a CLI-first system with deterministic builds and timestamped releases.

## Main Behavior

- Section-based generation: blog, links, pages, resume, learning.
- Publication into a timestamped folder under `releases/`.
- Atomic update of the `current` symlink to the latest valid release.
- Cleanup of old releases after successful publication.
- Failure isolation during dev mode: the last valid release remains served when rebuild fails.

## User Commands

- `hyweene build`
- `hyweene dev --host <host> --port <port>`
- `hyweene quick-add-link <url> [--comment <text>]`
- `hyweene check-dead-links [--path <dir>]`

Defaults:

- `dev` host: `0.0.0.0`
- `dev` port: `8000`

## Development Mode

Dev mode runs an initial build, serves the `current` folder, and rebuilds on each change in:

- `content/`
- `generator/Templates/`

## Architecture Direction

- Current runtime is generator-oriented with explicit CLI commands.
- Target architecture is Clean Architecture adapted to CLI:
	- Domain: entities, use cases, repository protocols
	- Data: repository implementations, DTO mapping, adapters
	- Runtime/App: CLI parsing and orchestration
- Migration is incremental to preserve output compatibility.
