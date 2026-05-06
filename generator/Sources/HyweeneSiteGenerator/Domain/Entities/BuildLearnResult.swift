/// The result of a successful learning modules generation run.
public struct BuildLearnResult: Sendable {
    /// Generated learning modules.
    public let modules: [LearnModuleEntity]

    /// Memberwise initialiser.
    public init(modules: [LearnModuleEntity]) {
        self.modules = modules
    }
}
