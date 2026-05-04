# SETUP

## Prérequis

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

## Mode développement

```bash
mise run dev
```

Serveur par défaut:

- host: `0.0.0.0`
- port: `1234`

## Tests

```bash
cd generator
swift test
```

## Exécution directe du binaire

```bash
cd generator
swift build
./.build/debug/hyweene build
./.build/debug/hyweene dev --host 0.0.0.0 --port 1234
./.build/debug/hyweene quick-add-link https://example.com
./.build/debug/hyweene quick-add-link https://example.com --comment "Great read"
./.build/debug/hyweene check-dead-links --path ../current
```
