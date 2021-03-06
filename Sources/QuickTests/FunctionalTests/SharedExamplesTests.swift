import Foundation
import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

class FunctionalTests_SharedExamples_Spec: QuickSpec {
    override func spec() {
        itBehavesLike("a group of three shared examples")
    }
}

class FunctionalTests_SharedExamples_ContextSpec: QuickSpec {
    override func spec() {
        itBehavesLike("shared examples that take a context") { [NSString(string: "callsite"): NSString(string: "SharedExamplesSpec")] }
    }
}

// Shared examples are defined in QuickTests/Fixtures
class SharedExamplesTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testAGroupOfThreeSharedExamplesExecutesThreeExamples", testAGroupOfThreeSharedExamplesExecutesThreeExamples),
            ("testSharedExamplesWithContextPassContextToExamples", testSharedExamplesWithContextPassContextToExamples),
        ]
    }

    func testAGroupOfThreeSharedExamplesExecutesThreeExamples() {
        let result = qck_runSpec(FunctionalTests_SharedExamples_Spec.self)
        XCTAssert(result.hasSucceeded)
        XCTAssertEqual(result.executionCount, 3 as UInt)
    }

    func testSharedExamplesWithContextPassContextToExamples() {
        let result = qck_runSpec(FunctionalTests_SharedExamples_ContextSpec.self)
        XCTAssert(result.hasSucceeded)
    }
}
