import XCTest

import class Foundation.Bundle

#if canImport(Testing)
    import Testing
#endif

final class swift_helloTests: XCTestCase {
    func testExample() throws {
        XCTAssert(true)
    }
}

#if canImport(Testing)
    @Test
    func swiftTesting() {
        #expect(Bool(true))
    }
#endif
