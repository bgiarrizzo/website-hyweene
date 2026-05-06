/// Protocol for rendering named templates with a context dictionary.
///
/// Implementations must be safe to call from any concurrency context.
public protocol TemplateRepository: Sendable {
    /// Render `template` with the given `context` and return the result as a string.
    func render(template: String, context: [String: Any]) throws -> String
}
