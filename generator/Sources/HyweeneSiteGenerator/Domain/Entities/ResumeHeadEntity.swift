/// Immutable domain entity for the resume header section.
public struct ResumeHeadEntity: Sendable {
    /// Rendered HTML body.
    public let body: String

    /// Memberwise initialiser.
    public init(body: String) {
        self.body = body
    }

    /// Returns a template dictionary matching legacy `ResumeHead.toDictionary()`.
    public func toDictionary() -> [String: Any] {
        ["body": body]
    }
}
