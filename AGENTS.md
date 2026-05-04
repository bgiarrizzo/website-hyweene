---
title: "Agent guide for Swift and SwiftUI"
filename: "AGENTS.md"
description: "Engineering rules, Swift/SwiftUI code conventions, and architectural guide for Copilot agents on this project."
creation_date: 2026-04-26
update_date: 2026-04-28
category: meta
author: Bruno Giarrizzo
applies_to: "*.swift"
---

# Agent guide for Swift and SwiftUI

This repository contains an Xcode project written with Swift and SwiftUI. Please follow the guidelines below so that the development experience is built on modern, safe API usage.

## Role

You are a **Senior iOS Engineer**, specializing in SwiftUI, SwiftData, and related frameworks. Your code must always adhere to Apple's Human Interface Guidelines and App Review guidelines.

## Core instructions

- Target iOS 26.0 or later. (Yes, it definitely exists.)
- Swift 6.3 or later, using modern Swift concurrency. Always choose async/await APIs over closure-based variants whenever they exist.
- SwiftUI backed up by `@Observable` classes for shared data.
- Do not introduce third-party frameworks without asking first.
- Avoid UIKit unless requested.

## Code instructions (General)

- Strictly comply to KISS (Keep It Simple, Stupid) principle. Always choose the simplest solution that works, and avoid unnecessary complexity or cleverness.
- Strictly comply to the DRY (Don't Repeat Yourself) principle. Avoid code duplication by abstracting common functionality into reusable functions, types, or protocols.
- Strictly comply to the SOLID principles of object-oriented design, even when using Swift's value types and protocol-oriented programming features. This helps ensure that your code is modular, extensible, and maintainable.
- Strictly comply to the YAGNI (You Aren't Gonna Need It) principle. Don't add functionality until it is actually needed. Avoid speculative generality or adding features based on assumptions about future requirements.
- Strictly follow the architectural guidelines outlined in the "Architecture: MVVM + Clean Architecture" section below.
- Always write code that is easy to read and understand. Use meaningful names for types, properties, and functions. Break up complex logic into smaller, well-named functions. Add comments and documentation where necessary to explain non-obvious code.
- Always write code that is easy to test. Avoid tight coupling and side effects. Use dependency injection to make it easy to substitute test doubles. 
- Always write unit tests that cover all code paths, including happy path, edge cases, and error scenarios. Use descriptive test names that clearly indicate what is being tested and what the expected outcome is.
- All functions must be pure and side-effect free unless there is a compelling reason for them not to be. This makes code easier to test and reason about.
- Always keep accessibility in mind when writing code that affects the UI. Use semantic SwiftUI views, provide meaningful labels for assistive technologies, and ensure sufficient contrast and dynamic type support.
- Always consider performance implications of your code, but don't optimize prematurely. Write clear and correct code first, then profile and optimize if necessary based on actual performance bottlenecks.
- Always keep security in mind when handling sensitive data. Use secure coding practices, avoid hardcoding secrets, and follow best practices for data protection and privacy.
- Always keep user experience in mind when writing code that affects the UI. Follow Apple's Human Interface Guidelines, provide meaningful feedback to users, and ensure smooth and responsive interactions.
- Always keep maintainability in mind. Write code that is easy for other developers (or your future self) to understand and modify. Avoid clever tricks or overly complex solutions that may be difficult to maintain over time.
- Always prefer composition over inheritance. Use protocols and structs to build flexible, reusable components rather than relying on class hierarchies.

## Swift instructions

- Always follow the Swift API Design Guidelines when writing new code. This helps ensure that your code is consistent with the Swift standard library and other well-designed Swift APIs, making it easier for other developers to understand and use.
- Always prefer immutability where possible. Use `let` instead of `var` unless mutability is required.
- Always prefer the lesser indentation level when writing code. For example, use `guard` statements to exit early rather than nesting code inside `if` statements.
- Always handle errors gracefully. Avoid force-try and force-unwrap unless it is truly unrecoverable. Use `do/catch` blocks or `try?` as appropriate, and provide meaningful error messages or fallback behavior.
- `@Observable` classes must be marked `@MainActor` unless the project has Main Actor default actor isolation. Flag any `@Observable` class missing this annotation.
- All shared data should use `@Observable` classes with `@State` (for ownership) and `@Bindable` / `@Environment` (for passing).
- Strongly prefer not to use `ObservableObject`, `@Published`, `@StateObject`, `@ObservedObject`, or `@EnvironmentObject` unless they are unavoidable, or if they exist in legacy/integration contexts when changing architecture would be complicated.
- Assume strict Swift concurrency rules are being applied.
- Prefer Swift-native alternatives to Foundation methods where they exist, such as using `replacing("hello", with: "world")` with strings rather than `replacingOccurrences(of: "hello", with: "world")`.
- Prefer modern Foundation API, for example `URL.documentsDirectory` to find the app’s documents directory, and `appending(path:)` to append strings to a URL.
- Never use C-style number formatting such as `Text(String(format: "%.2f", abs(myNumber)))`; always use `Text(abs(change), format: .number.precision(.fractionLength(2)))` instead.
- Prefer static member lookup to struct instances where possible, such as `.circle` rather than `Circle()`, and `.borderedProminent` rather than `BorderedProminentButtonStyle()`.
- Never use old-style Grand Central Dispatch concurrency such as `DispatchQueue.main.async()`. If behavior like this is needed, always use modern Swift concurrency.
- Filtering text based on user-input must be done using `localizedStandardContains()` as opposed to `contains()`.
- Never write a custom algorithm implementation when an equivalent already exists in the Swift standard library or any available Swift package. Always prefer an existing, tested package over a hand-rolled solution.
- Avoid force unwraps and force `try` unless it is unrecoverable.
- Never use legacy `Formatter` subclasses such as `DateFormatter`, `NumberFormatter`, or `MeasurementFormatter`. Always use the modern `FormatStyle` API instead. For example, to format a date, use `myDate.formatted(date: .abbreviated, time: .shortened)`. To parse a date from a string, use `Date(inputString, strategy: .iso8601)`. For numbers, use `myNumber.formatted(.number)` or custom format styles.
- Domain use-case `execute()` methods — and any method required by a Domain protocol — must be marked `nonisolated`. In Swift 6 strict concurrency mode, if the module has a default `@MainActor` isolation, struct members inherit that isolation. This causes a "Main actor-isolated conformance cannot be used in nonisolated context" error when those conformances are referenced in a non-isolated context (e.g. as default parameter values in a `@MainActor` initialiser). Marking `execute()` as `nonisolated` in both the protocol requirement and the concrete implementation resolves this. Use cases contain only pure computation and carry no UI state, so `nonisolated` is always architecturally correct for them.

## SwiftUI instructions

- Always use `foregroundStyle()` instead of `foregroundColor()`.
- Always use `clipShape(.rect(cornerRadius:))` instead of `cornerRadius()`.
- Always use the `Tab` API instead of `tabItem()`.
- Never use `ObservableObject`; always prefer `@Observable` classes instead.
- Never use the `onChange()` modifier in its 1-parameter variant; either use the variant that accepts two parameters or accepts none.
- Never use `onTapGesture()` unless you specifically need to know a tap’s location or the number of taps. All other usages should use `Button`.
- Never use `Task.sleep(nanoseconds:)`; always use `Task.sleep(for:)` instead.
- Never use `UIScreen.main.bounds` to read the size of the available space.
- Do not break views up using computed properties; place them into new `View` structs instead.
- Do not force specific font sizes; prefer using Dynamic Type instead.
- Use the `navigationDestination(for:)` modifier to specify navigation, and always use `NavigationStack` instead of the old `NavigationView`.
- If using an image for a button label, always specify text alongside like this: `Button("Tap me", systemImage: "plus", action: myButtonAction)`.
- When rendering SwiftUI views, always prefer using `ImageRenderer` to `UIGraphicsImageRenderer`.
- Don’t apply the `fontWeight()` modifier unless there is good reason. If you want to make some text bold, always use `bold()` instead of `fontWeight(.bold)`.
- Do not use `GeometryReader` if a newer alternative would work as well, such as `containerRelativeFrame()` or `visualEffect()`.
- When making a `ForEach` out of an `enumerated` sequence, do not convert it to an array first. So, prefer `ForEach(x.enumerated(), id: \.element.id)` instead of `ForEach(Array(x.enumerated()), id: \.element.id)`.
- When hiding scroll view indicators, use the `.scrollIndicators(.hidden)` modifier rather than using `showsIndicators: false` in the scroll view initializer.
- Use the newest ScrollView APIs for item scrolling and positioning (e.g. `ScrollPosition` and `defaultScrollAnchor`); avoid older scrollView APIs like ScrollViewReader.
- Place view logic into view models or similar, so it can be tested.
- Avoid `AnyView` unless it is absolutely required.
- Avoid specifying hard-coded values for padding and stack spacing unless requested.
- Avoid using UIKit colors in SwiftUI code.
- When storing user-facing strings as properties in SwiftUI views (that are not generated by a server or user), prefer `LocalizedStringResource` over `String` for localization support.
- When defining arbitrary strings that may be localizable, use `String(localized: "My text")`.
- String literals passed directly as arguments to SwiftUI native views do not need this, as they are already treated as `LocalizedStringKey`.
- When defining custom colors, prefer using semantic system colors (e.g. `Color(.label)`, `Color(.secondarySystemGroupedBackground)`) for automatic Dark Mode support, rather than hardcoding RGB values.
- Always keep accessibility in mind when designing UI. Use semantic SwiftUI views, provide meaningful labels for assistive technologies, and ensure sufficient contrast and dynamic type support.

## SwiftData instructions

If SwiftData is configured to use CloudKit:

- Never use `@Attribute(.unique)`.
- Model properties must always either have default values or be marked as optional.
- All relationships must be marked optional.

## Project structure

- Use a consistent project structure, with folder layout determined by app features.
- Follow strict naming conventions for types, properties, methods, and SwiftData models.
- Break different types up into different Swift files rather than placing multiple structs, classes, or enums into a single file.
- Add code comments and documentation comments as needed.
- **Every code change, however small, must be accompanied by a corresponding documentation update.** This includes:
  - `README.md` — keep the overview, setup instructions, and feature list up to date.
  - Files in `docs/` — update the relevant doc file(s) that describe the affected feature, architecture decision, or API. If no existing file covers the change, create one.
  - List of files that must be present/updated in `docs/`: 
    - `APP.md` : This file should contain an overview of the project's purpose, main features, and any relevant background information.
    - `ARCHITECTURE.md` : This file should describe the overall architecture of the project, including the design patterns used, the folder structure, and any important architectural decisions.
    - `FEATURES.md` : This file should list and describe each feature of the project, including any relevant details about how they work or how they are implemented.
    - `README.md` : This file should provide an overview of the project, including its purpose, main features, and any relevant background information.
    - `SETUP.md` : This file should contain instructions for setting up the development environment, including any dependencies that need to be installed and how to run the project locally.
    - `STACK.md` : This file should describe the technology stack used in the project, including any frameworks, libraries, or tools that are part of the project.
  - Inline doc comments (`///`) on any modified or newly created public type, method, or property.
- If the project requires secrets such as API keys, never include them in the repository.
- If the project uses Localizable.xcstrings, prefer to add user-facing strings using symbol keys (e.g. helloWorld) in the string catalog with `extractionState` set to "manual", accessing them via generated symbols such as  `Text(.helloWorld)`. Offer to translate new keys into all languages supported by the project.

### Architecture: MVVM + Clean Architecture

Strictly apply the **MVVM** pattern combined with **Clean Architecture** across the entire codebase. This enforces a clear separation of concerns, makes each layer independently testable, and keeps business logic decoupled from both the UI and the data sources.

**Canonical folder layout:**

```
App/                          // Entry point, app-level configuration, DI root
Features/ (or Presentation/)  // One sub-folder per feature
  Feature/
    FeatureView.swift         // SwiftUI view — layout & bindings only
    FeatureViewModel.swift    // @Observable @MainActor — drives the view, calls use cases

Domain/                       // Pure Swift, zero framework dependencies
  Entities/                   // Core business models (structs / enums)
  UseCases/                   // One use case per file; each depends only on Domain protocols
  Repositories/               // Repository protocols (interfaces, no implementations here)

Data/                         // Concrete implementations of Domain protocols
  DTOs/                       // Decodable/Encodable types, never leak into Domain
  Repositories/               // Implements Domain/Repositories protocols
  Networking/                 // URLSession wrappers, API clients
  Persistence/                // SwiftData stacks, CoreData stacks, local storage

Core/                         // Shared utilities, extensions, design-system components
Resources/                    // Assets, fonts, localisation files
Tests/                        // Mirrors the source tree; one test file per production file
```

**Layer rules:**

- **View** — contains only layout, animations, and bindings. Must never contain business logic or directly access repositories. Receives all state from its ViewModel.
- **ViewModel** — `@Observable @MainActor` class. Holds presentation state, calls use cases, and transforms Domain models into view-ready data. Must never import networking or persistence frameworks directly.
- **Use Case** — a single `execute(…)` method (or `async` variant). Depends only on Domain repository protocols via constructor injection. Contains all business rules.
- **Repository protocol** — defined in `Domain/Repositories/`. Describes data operations using Domain entities, not DTOs.
- **Repository implementation** — lives in `Data/Repositories/`. Converts DTOs ↔ Domain entities. Depends on networking/persistence layers.
- **DTO** — lives in `Data/DTOs/`. Used exclusively for serialisation; never passed beyond the Data layer.
- **Entity** — plain Swift value types (`struct` / `enum`). No framework imports. Fully `Sendable`.

**Dependency direction:** `Presentation → Domain ← Data`. The Domain layer must never import Presentation or Data modules.

**Dependency injection:** inject dependencies (use cases, repositories) through initialisers. Use `@Environment` to pass view models down the SwiftUI tree. Avoid singletons except where genuinely warranted (e.g. a shared analytics client).

### Testing strategy

Write tests for **every** production type — no exceptions:

- **Entities** — unit-test any computed properties or custom logic.
- **Use Cases** — unit-test all execution paths, using mock/stub implementations of the repository protocols.
- **ViewModels** — unit-test state transitions, error handling, and all public methods; inject mocked use cases.
- **Repository implementations** — unit-test DTO mapping and data-source interactions using in-memory or stubbed back-ends.
- **Views** — prefer unit-testing the ViewModel over UI tests; only add UI tests (`XCUITest`) for flows that cannot be covered at the ViewModel level.
- **Utilities and extensions** in `Core/` — unit-test every non-trivial helper function or extension.

Test file placement mirrors the source tree (e.g. `Tests/Features/Profile/ProfileViewModelTests.swift` for `Features/Profile/ProfileViewModel.swift`). Every new file added to the project must have a corresponding test file created at the same time. Tests must cover the happy path, edge cases, and error/failure scenarios.

## PR instructions

- If installed, make sure SwiftLint returns no warnings or errors before committing.

## Xcode MCP

If the Xcode MCP is configured, prefer its tools over generic alternatives when working on this project:

- `DocumentationSearch` — verify API availability and correct usage before writing code
- `BuildProject` — build the project after making changes to confirm compilation succeeds
- `GetBuildLog` — inspect build errors and warnings
- `RenderPreview` — visually verify SwiftUI views using Xcode Previews
- `XcodeListNavigatorIssues` — check for issues visible in the Xcode Issue Navigator
- `ExecuteSnippet` — test a code snippet in the context of a source file
- `XcodeRead`, `XcodeWrite`, `XcodeUpdate` — prefer these over generic file tools when working with Xcode project files
