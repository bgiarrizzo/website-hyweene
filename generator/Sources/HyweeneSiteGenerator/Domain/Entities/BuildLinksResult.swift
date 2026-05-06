/// The result of a successful links generation run.
public struct BuildLinksResult: @unchecked Sendable {
    /// Links sorted by publish date descending.
    public let links: [LinkItemEntity]

    /// Memberwise initialiser.
    public init(links: [LinkItemEntity]) {
        self.links = links
    }
}
