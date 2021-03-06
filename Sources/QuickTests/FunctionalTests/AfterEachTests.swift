import XCTest
import Quick
import Nimble
#if SWIFT_PACKAGE
import QuickTestHelpers
#endif

private enum AfterEachType {
    case OuterOne
    case OuterTwo
    case OuterThree
    case InnerOne
    case InnerTwo
    case NoExamples
}

private var afterEachOrder = [AfterEachType]()

class FunctionalTests_AfterEachSpec: QuickSpec {
    override func spec() {
        afterEach { afterEachOrder.append(AfterEachType.OuterOne) }
        afterEach { afterEachOrder.append(AfterEachType.OuterTwo) }
        afterEach { afterEachOrder.append(AfterEachType.OuterThree) }

        it("executes the outer afterEach closures once, but not before this closure [1]") {
            // No examples have been run, so no afterEach will have been run either.
            // The list should be empty.
            expect(afterEachOrder).to(beEmpty())
        }

        it("executes the outer afterEach closures a second time, but not before this closure [2]") {
            // The afterEach for the previous example should have been run.
            // The list should contain the afterEach for that example, executed from top to bottom.
            expect(afterEachOrder).to(equal([AfterEachType.OuterOne, AfterEachType.OuterTwo, AfterEachType.OuterThree]))
        }

        context("when there are nested afterEach") {
            afterEach { afterEachOrder.append(AfterEachType.InnerOne) }
            afterEach { afterEachOrder.append(AfterEachType.InnerTwo) }

            it("executes the outer and inner afterEach closures, but not before this closure [3]") {
                // The afterEach for the previous two examples should have been run.
                // The list should contain the afterEach for those example, executed from top to bottom.
                expect(afterEachOrder).to(equal([
                    AfterEachType.OuterOne, AfterEachType.OuterTwo, AfterEachType.OuterThree,
                    AfterEachType.OuterOne, AfterEachType.OuterTwo, AfterEachType.OuterThree,
                ]))
            }
        }

        context("when there are nested afterEach without examples") {
            afterEach { afterEachOrder.append(AfterEachType.NoExamples) }
        }
    }
}

class AfterEachTests: XCTestCase, XCTestCaseProvider {
    var allTests: [(String, () -> Void)] {
        return [
            ("testAfterEachIsExecutedInTheCorrectOrder", testAfterEachIsExecutedInTheCorrectOrder),
        ]
    }

    func testAfterEachIsExecutedInTheCorrectOrder() {
        afterEachOrder = []

        qck_runSpec(FunctionalTests_AfterEachSpec.self)
        let expectedOrder = [
            // [1] The outer afterEach closures are executed from top to bottom.
            AfterEachType.OuterOne, AfterEachType.OuterTwo, AfterEachType.OuterThree,
            // [2] The outer afterEach closures are executed from top to bottom.
            AfterEachType.OuterOne, AfterEachType.OuterTwo, AfterEachType.OuterThree,
            // [3] The inner afterEach closures are executed from top to bottom,
            //     then the outer afterEach closures are executed from top to bottom.
            AfterEachType.InnerOne, AfterEachType.InnerTwo,
                AfterEachType.OuterOne, AfterEachType.OuterTwo, AfterEachType.OuterThree,
        ]
        XCTAssertEqual(afterEachOrder, expectedOrder)

        afterEachOrder = []
    }
}
