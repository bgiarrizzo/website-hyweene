# SETUP

## Prerequisites

- macOS
- Swift 6+

## Installation

```bash
mise run install
```

## Build

```bash
mise run build
```

## Development Mode

```bash
mise run dev
```

Default server:

- host: `0.0.0.0`
- port: `1234`

## Tests

```bash
cd generator
swift test
```

## Direct Binary Execution

```bash
cd generator
swift build
./.build/debug/hyweene build
./.build/debug/hyweene dev --host 0.0.0.0 --port 1234
./.build/debug/hyweene quick-add-link https://example.com
./.build/debug/hyweene quick-add-link https://example.com --comment "Great read"
./.build/debug/hyweene check-dead-links --path ../current
```
