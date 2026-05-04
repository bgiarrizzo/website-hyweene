// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HyweeneSiteGenerator",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        // Library product for the main logic (testable)
        .library(
            name: "HyweeneSiteGenerator",
            targets: ["HyweeneSiteGenerator"]
        )
    ],
    dependencies: [
        // Markdown processing
        .package(url: "https://github.com/JohnSundell/Ink.git", from: "0.6.0"),
        // Template engine (Jinja2-like)
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.15.1"),
        // YAML parsing
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.0.0"),
        // Swift Testing framework
        .package(url: "https://github.com/apple/swift-testing.git", from: "0.10.0"),
    ],
    targets: [
        // Library containing all the logic (testable)
        .target(
            name: "HyweeneSiteGenerator",
            dependencies: [
                .product(name: "Ink", package: "Ink"),
                .product(name: "Stencil", package: "Stencil"),
                .product(name: "Yams", package: "Yams"),
            ],
            path: "Sources/HyweeneSiteGenerator",
            exclude: [
                "Main.swift"  // Exclude main.swift from the library target
            ],
        ),
        // Executable target for the command-line tool
        .executableTarget(
            name: "hyweene",
            dependencies: [
                .target(name: "HyweeneSiteGenerator")
            ],
            path: "Sources/HyweeneSiteGenerator",
            sources: ["Main.swift"]
        ),
        // Tests, calls the library code
        .testTarget(
            name: "HyweeneSiteGeneratorTests",
            dependencies: [
                .target(name: "HyweeneSiteGenerator"),
                .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/HyweeneSiteGeneratorTests",
        ),
    ]
)
