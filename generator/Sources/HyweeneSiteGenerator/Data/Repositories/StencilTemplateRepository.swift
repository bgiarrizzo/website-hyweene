import Foundation

/// `TemplateRepository` implementation backed by the Stencil template engine.
///
/// Adds the `site` context and standard filters from `TemplateEngine`.
/// `@unchecked Sendable` because `TemplateEngine` holds an immutable Stencil
/// `Environment` after initialisation, making concurrent reads safe.
public struct StencilTemplateRepository: TemplateRepository, @unchecked Sendable {
    private let engine: TemplateEngine

    /// - Parameter templatePath: Absolute path to the Stencil templates directory.
    /// - Throws: `TemplateEngineError` if the template path is invalid.
    public init(templatePath: String) throws {
        self.engine = try TemplateEngine(templatePath: templatePath)
    }

    // MARK: - TemplateRepository

    public func render(template: String, context: [String: Any]) throws -> String {
        try engine.renderWithData(template: template, dataList: [context])
    }
}
