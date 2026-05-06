# FEATURES

## Content Generation

- Blog: posts, category pages, listing, RSS, sitemap
- Links: individual pages, listing, RSS, sitemap
- Static pages: about/now/projects and related pages
- Learning: modules, tables of contents, pages
- Resume: resume page generation

## Performance

- Independent generators run in parallel
- Parallel rendering of independent items (posts, links, pages, modules)

## Reliability

- Timestamped releases avoid partial deploy states.
- `current` symlink switches atomically to the latest valid build.
- Old releases are cleaned automatically to limit disk growth.
- Dev server keeps serving latest valid release when rebuild fails.

## Architecture Work In Progress

- Progressive migration toward Domain use cases and repository boundaries.
- Incremental refactor policy to preserve generated output compatibility.
- Tests are expanded per migrated component (domain/data/runtime).

## CLI Commands

- `hyweene build`: one-time build
- `hyweene dev --host <host> --port <port>`: build + watch + local server
- `hyweene quick-add-link <url> [--comment <text>]`: create a new link file from the remote page title
- `hyweene check-dead-links [--path <dir>]`: detect dead external links (404) in generated HTML

## Project Automation

- Project tasks exposed through `mise` (`mise run install|build|dev|test|serve|quick_add_link`)

## Publication Reliability

- Build into a timestamped folder
- Switch via the `current` symlink
- Automatic cleanup of older releases
