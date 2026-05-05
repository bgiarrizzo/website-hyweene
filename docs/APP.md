# APP

## Purpose

This project generates a personal static site (hyweene.fr) from Markdown/YAML content and Stencil templates.

## Main Behavior

- Section-based generation: blog, links, pages, resume, learning.
- Publication into a timestamped folder under `releases/`.
- Atomic update of the `current` symlink to the latest valid release.

## User Commands

- `hyweene build`
- `hyweene dev --host <host> --port <port>`
- `hyweene quick-add-link <url> [--comment <text>]`
- `hyweene check-dead-links [--path <dir>]`

## Development Mode

Dev mode runs an initial build, serves the `current` folder, and rebuilds on each change in:

- `content/`
- `generator/Templates/`
