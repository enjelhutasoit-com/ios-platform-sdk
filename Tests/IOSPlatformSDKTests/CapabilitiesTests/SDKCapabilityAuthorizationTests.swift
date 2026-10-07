//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKCapabilityAuthorizationTests: XCTestCase {
    func test_authorizationAllowsRegisteredAction() {
        let authorization = SDKCapabilityAuthorization(
            allowedActions: ["open"]
        )
        
        XCTAssertTrue(
            authorization.isAllowed(
                SDKWebViewMessage(action: "open")
            )
        )
    }
    
    func test_authorizationRejectsUnregisteredAction() {
        let authorization = SDKCapabilityAuthorization(
            allowedActions: ["open"]
        )
        
        XCTAssertFalse(
            authorization.isAllowed(
                SDKWebViewMessage(action: "camera")
            )
        )
    }
    
    func test_authorizationRejectsAllActionsWhenEmpty() {
        let authorization = SDKCapabilityAuthorization(
            allowedActions: []
        )
        
        XCTAssertFalse(
            authorization.isAllowed(
                SDKWebViewMessage(action: "open")
            )
        )
    }
}
