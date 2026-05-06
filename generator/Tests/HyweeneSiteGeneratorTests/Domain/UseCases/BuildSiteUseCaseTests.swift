import Foundation
import Testing

@testable import HyweeneSiteGenerator

struct BuildSiteUseCaseTests {
    @Test("Use case executes injected build operation")
    func executeInjectedBuildOperation() throws {
        let expected = BuildSummary(
            blogPosts: 3,
            links: 5,
            pages: 4,
            learningModules: 2,
            learningPages: 7,
            categories: 2
        )

        let useCase = BuildSiteUseCase(buildOperation: {
            expected
        })

        let result = try useCase.execute()

        #expect(result.blogPosts == expected.blogPosts)
        #expect(result.links == expected.links)
        #expect(result.pages == expected.pages)
        #expect(result.learningModules == expected.learningModules)
        #expect(result.learningPages == expected.learningPages)
        #expect(result.categories == expected.categories)
    }

    @Test("Use case rethrows build operation errors")
    func rethrowsBuildOperationErrors() {
        enum TestError: Error {
            case boom
        }

        let useCase = BuildSiteUseCase(buildOperation: {
            throw TestError.boom
        })

        #expect(throws: TestError.self) {
            _ = try useCase.execute()
        }
    }
}
