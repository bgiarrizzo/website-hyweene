/// Protocol for loading a validated resume aggregate from content sources.
public protocol ResumeContentRepository: Sendable {
    /// Load and return the full resume aggregate.
    func loadResume() throws -> ResumeEntity
}
