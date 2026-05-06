import Foundation
import Yams

/// `LearnContentRepository` implementation backed by module YAML and Markdown files on disk.
public struct FileSystemLearnContentRepository: LearnContentRepository {
    private let learnPath: String

    /// - Parameter learnPath: Absolute path to the learning modules content root.
    public init(learnPath: String) {
        self.learnPath = learnPath
    }

    // MARK: - LearnContentRepository

    public func loadModules() throws -> [LearnModuleEntity] {
        let moduleFiles = FileManager.default.getAllFiles(from: learnPath, withExtension: ".yml")
        var modules: [LearnModuleEntity] = []

        for moduleFile in moduleFiles {
            let rawModuleData = try parseModuleFile(moduleFile.path)
            let moduleDirectory = moduleFile.deletingLastPathComponent().path

            let pageFiles = FileManager.default.getAllFiles(
                from: moduleDirectory, withExtension: ".md")
            let pageDTOs = try pageFiles.map { fileURL in
                let rawPageData = try parseMarkdownFile(fileURL.path)
                return LearnModulePageDTO(from: rawPageData, filePath: fileURL.path)
            }.filter { !$0.disabled }

            let moduleDTO = LearnModuleDTO(
                from: rawModuleData,
                filePath: moduleFile.path,
                pages: pageDTOs
            )

            if moduleDTO.disabled {
                continue
            }

            modules.append(try LearnModuleMapper.toEntity(from: moduleDTO))
        }

        return modules.sorted { ($0.id ?? 0) < ($1.id ?? 0) }
    }

    private func parseModuleFile(_ filePath: String) throws -> [String: Any] {
        let fileURL = URL(fileURLWithPath: filePath)
        let yamlContent = try String(contentsOf: fileURL, encoding: .utf8)

        guard let data = try Yams.load(yaml: yamlContent) as? [String: Any] else {
            throw NSError(
                domain: "FileSystemLearnContentRepository", code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: "Invalid YAML in module file: \(filePath)"
                ])
        }

        return data
    }
}
