import Foundation

private final class ConcurrentWorkItem: @unchecked Sendable {
    let work: () throws -> Void

    init(work: @escaping () throws -> Void) {
        self.work = work
    }
}

private final class ConcurrentErrorState: @unchecked Sendable {
    private let lock = NSLock()
    private var firstError: Error?

    func shouldRun() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return firstError == nil
    }

    func store(_ error: Error) {
        lock.lock()
        defer { lock.unlock() }
        if firstError == nil {
            firstError = error
        }
    }

    func get() -> Error? {
        lock.lock()
        defer { lock.unlock() }
        return firstError
    }
}

/// Error thrown when one or more concurrent operations fail.
public enum ConcurrentExecutorError: Error {
    case operationFailed(Error)
}

/// Execute multiple independent operations in parallel and fail fast on first error.
/// - Parameters:
///   - maxConcurrentOperationCount: Maximum number of parallel operations.
///   - operations: Independent throwing closures.
/// - Throws: `ConcurrentExecutorError.operationFailed` on first failure.
public func runConcurrently(
    maxConcurrentOperationCount: Int = ProcessInfo.processInfo.processorCount,
    operations: [() throws -> Void]
) throws {
    guard !operations.isEmpty else {
        return
    }

    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = max(1, maxConcurrentOperationCount)

    let state = ConcurrentErrorState()
    let workItems = operations.map(ConcurrentWorkItem.init)

    for item in workItems {
        queue.addOperation {
            guard state.shouldRun() else {
                return
            }

            do {
                try item.work()
            } catch {
                state.store(error)
                queue.cancelAllOperations()
            }
        }
    }

    queue.waitUntilAllOperationsAreFinished()

    if let error = state.get() {
        throw ConcurrentExecutorError.operationFailed(error)
    }
}
