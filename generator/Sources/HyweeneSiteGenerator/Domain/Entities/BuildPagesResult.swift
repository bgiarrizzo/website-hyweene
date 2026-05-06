/// The result of a successful pages generation run.
public struct BuildPagesResult: Sendable {
    /// Generated pages.
    public let pages: [PageEntity]

    /// Memberwise initialiser.
    public init(pages: [PageEntity]) {
        self.pages = pages
    }
}
