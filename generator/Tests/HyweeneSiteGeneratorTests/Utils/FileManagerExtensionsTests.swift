import Foundation
import Testing
@testable import HyweeneSiteGenerator

struct FileManagerExtensionsTests {
    // MARK: - FileManager Extensions Tests

    @Test("Create directory if needed creates new directory")
    func createDirectoryCreatesNew() throws {
        let fm = FileManager.default
        let tempDir = NSTemporaryDirectory()
        let testPath = "\(tempDir)test_dir_\(UUID().uuidString)"
        
        defer { try? fm.removeItem(atPath: testPath) }
        
        try fm.createDirectoryIfNeeded(at: testPath)
        
        var isDirectory: ObjCBool = false
        let exists = fm.fileExists(atPath: testPath, isDirectory: &isDirectory)
        
        #expect(exists)
        #expect(isDirectory.boolValue)
    }

    @Test("Create directory if needed handles existing directory")
    func createDirectoryHandlesExisting() throws {
        let fm = FileManager.default
        let tempDir = NSTemporaryDirectory()
        let testPath = "\(tempDir)test_existing_\(UUID().uuidString)"
        
        defer { try? fm.removeItem(atPath: testPath) }
        
        // Create first time
        try fm.createDirectoryIfNeeded(at: testPath)
        // Should not throw on second call
        try fm.createDirectoryIfNeeded(at: testPath)
        
        #expect(fm.fileExists(atPath: testPath))
    }

    @Test("Get all files returns markdown files")
    func getAllFilesReturnsMarkdown() throws {
        let fm = FileManager.default
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("test_\(UUID().uuidString)")
        
        defer { try? fm.removeItem(at: tempDir) }
        
        try fm.createDirectory(at: tempDir, withIntermediateDirectories: true)
        
        // Create test files
        let mdFile1 = tempDir.appendingPathComponent("test1.md")
        let mdFile2 = tempDir.appendingPathComponent("test2.md")
        let txtFile = tempDir.appendingPathComponent("test.txt")
        
        try "content".write(to: mdFile1, atomically: true, encoding: .utf8)
        try "content".write(to: mdFile2, atomically: true, encoding: .utf8)
        try "content".write(to: txtFile, atomically: true, encoding: .utf8)
        
        let mdFiles = fm.getAllFiles(from: tempDir.path, withExtension: ".md")
        
        #expect(mdFiles.count == 2)
        #expect(mdFiles.contains(where: { $0.lastPathComponent == "test1.md" }))
        #expect(mdFiles.contains(where: { $0.lastPathComponent == "test2.md" }))
    }

    @Test("Write and read file operations")
    func writeAndReadFile() throws {
        let fm = FileManager.default
        let tempDir = NSTemporaryDirectory()
        let testPath = "\(tempDir)test_file_\(UUID().uuidString).txt"
        
        defer { try? fm.removeItem(atPath: testPath) }
        
        let content = "Test content with émojis 🚀 and accents éàü"
        
        try fm.writeFile(content: content, to: testPath)
        let readContent = try fm.readFile(from: testPath)
        
        #expect(readContent == content)
    }

    @Test("Copy directory copies all contents")
    func copyDirectoryCopiesContents() throws {
        let fm = FileManager.default
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
        let sourceDir = tempDir.appendingPathComponent("source_\(UUID().uuidString)")
        let destDir = tempDir.appendingPathComponent("dest_\(UUID().uuidString)")
        
        defer {
            try? fm.removeItem(at: sourceDir)
            try? fm.removeItem(at: destDir)
        }
        
        try fm.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        
        let testFile = sourceDir.appendingPathComponent("test.txt")
        try "content".write(to: testFile, atomically: true, encoding: .utf8)
        
        try fm.copyDirectory(from: sourceDir.path, to: destDir.path)
        
        let copiedFile = destDir.appendingPathComponent("test.txt")
        #expect(fm.fileExists(atPath: copiedFile.path))
        
        let copiedContent = try String(contentsOf: copiedFile, encoding: .utf8)
        #expect(copiedContent == "content")
    }
}