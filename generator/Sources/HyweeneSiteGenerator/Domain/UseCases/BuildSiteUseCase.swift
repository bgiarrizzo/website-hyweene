import Foundation

/// Domain use case responsible for triggering a full site build.
///
/// The build operation is injectable to keep the use case deterministic in tests.
public struct BuildSiteUseCase: Sendable {
    /// Function signature used by the use case to perform the build.
    public typealias BuildOperation = @Sendable () throws -> BuildSummary

    private let buildOperation: BuildOperation

    /// Creates a build use case.
    /// - Parameter buildOperation: Callable build implementation. Defaults to `buildSite`.
    public init(buildOperation: @escaping BuildOperation = buildSite) {
        self.buildOperation = buildOperation
    }

    /// Executes a full site build.
    /// - Returns: A `BuildSummary` containing generation metrics.
    /// - Throws: Any error raised by the underlying build operation.
    @discardableResult
    public nonisolated func execute() throws -> BuildSummary {
        try buildOperation()
    }
}
