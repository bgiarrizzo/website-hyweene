# STACK

## Language and Runtime

- Swift 6
- Swift Package Manager

## Libraries

- Ink (Markdown)
- Yams (YAML)
- Stencil (templates)
- swift-argument-parser (CLI parsing, subcommands, and options)
- Swift Testing (tests, via toolchain or `swift-testing` package fallback)
- FoundationNetworking (Linux, for URLSession/URLRequest APIs)

## Tools and Patterns

- Task runner: `mise` (`mise.toml`)
- CLI custom (`hyweene build`, `hyweene dev`, `hyweene quick-add-link [--comment <text>]`, `hyweene check-dead-links`)
- Concurrent executor for independent tasks
- Snapshot-based file watcher with polling
- Minimal local HTTP server via `Network`, with native Swift fallback (POSIX sockets) when `Network` is unavailable (e.g., Linux)
