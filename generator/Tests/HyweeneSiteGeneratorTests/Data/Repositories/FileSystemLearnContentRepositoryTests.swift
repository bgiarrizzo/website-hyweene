import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct FileSystemLearnContentRepositoryTests {
    @Test("loadModules returns enabled modules and enabled pages")
    func returnsEnabledModulesAndPages() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let moduleDir = tempDir.appendingPathComponent("1 - git")
        try fm.createDirectory(at: moduleDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        try """
        id: 1
        name: Git
        description: desc
        """.write(to: moduleDir.appendingPathComponent("00-module.yml"), atomically: true, encoding: .utf8)

        try """
        ---
        id: 2
        title: Second Page
        ---

        Body
        """.write(to: moduleDir.appendingPathComponent("02-second.md"), atomically: true, encoding: .utf8)

        try """
        ---
        id: 1
        title: First Page
        disabled: false
        tags: git, vcs
        ---

        Body
        """.write(to: moduleDir.appendingPathComponent("01-first.md"), atomically: true, encoding: .utf8)

        try """
        ---
        id: 3
        title: Disabled Page
        disabled: true
        ---

        Body
        """.write(to: moduleDir.appendingPathComponent("03-disabled.md"), atomically: true, encoding: .utf8)

        let repository = FileSystemLearnContentRepository(learnPath: tempDir.path)
        let modules = try repository.loadModules()

        #expect(modules.count == 1)
        #expect(modules.first?.pages.map(\.title) == ["First Page", "Second Page"])
        #expect(modules.first?.pages.first?.tags == ["git", "vcs"])
    }

    @Test("loadModules skips disabled module descriptors")
    func skipsDisabledModules() throws {
        let fm = FileManager.default
        let tempDir = fm.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let moduleDir = tempDir.appendingPathComponent("1 - git")
        try fm.createDirectory(at: moduleDir, withIntermediateDirectories: true)
        defer { try? fm.removeItem(at: tempDir) }

        try """
        id: 1
        name: Git
        disabled: true
        """.write(to: moduleDir.appendingPathComponent("00-module.yml"), atomically: true, encoding: .utf8)

        let repository = FileSystemLearnContentRepository(learnPath: tempDir.path)
        let modules = try repository.loadModules()

        #expect(modules.isEmpty)
    }
}