//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKWebViewBridgeTests: XCTestCase {
    @MainActor
    func test_bridge_usesDefaultHandlerName() {
        let bridge = SDKWebViewBridge()
        
        XCTAssertNotNil(bridge)
    }
    
    @MainActor
    func test_bridge_canUseCustomHandlerName() {
        let bridge = SDKWebViewBridge(handlerName: "customBridge")
        
        XCTAssertNotNil(bridge)
    }
}
