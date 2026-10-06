//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKStateTests:  XCTestCase {
    func test_statesAreEquatable() {
        XCTAssertEqual(SDKState.idle, .idle)
        XCTAssertNotEqual(SDKState.idle, .ready)
    }
}
