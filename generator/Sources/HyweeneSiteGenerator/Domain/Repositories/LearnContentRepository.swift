/// Protocol for loading validated learning modules from content sources.
public protocol LearnContentRepository: Sendable {
    /// Load and return all enabled learning modules.
    func loadModules() throws -> [LearnModuleEntity]
}
