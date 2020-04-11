import XCTest
@testable import RichTextKit

final class RichTextKitTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RichTextKit().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
