/// The result of a successful resume generation run.
public struct BuildResumeResult: Sendable {
    /// Generated resume aggregate.
    public let resume: ResumeEntity

    /// Memberwise initialiser.
    public init(resume: ResumeEntity) {
        self.resume = resume
    }
}
