//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKCapabilityRegistryTests: XCTestCase {
    func test_registryExecutesRegisteredCapability() {
        let registry = SDKCapabilityRegistry()
        var receivedMessage: SDKWebViewMessage?

        registry.register(
            SDKCapabilityMock(action: "open") { message in
                receivedMessage = message
            }
        )

        let message = SDKWebViewMessage(
            action: "open",
            payload: ["screen": "profile"]
        )
        
        let authorization = SDKCapabilityAuthorization(
            allowedActions: ["open"]
        )

        registry.execute(
            message,
            authorization: authorization
        )

        XCTAssertEqual(receivedMessage, message)
    }

    func test_registryIgnoresUnregisteredCapability() {
        let registry = SDKCapabilityRegistry()

        let authorization = SDKCapabilityAuthorization(
            allowedActions: ["unknown"]
        )

        XCTAssertFalse(
            registry.execute(
                SDKWebViewMessage(action: "unknown"),
                authorization: authorization
            )
        )
    }

    func test_registryReturnsTrueWhenCapabilityExecutes() {
        let registry = SDKCapabilityRegistry()

        registry.register(
            SDKCapabilityMock(action: "test") { _ in }
        )
        
        let authorization = SDKCapabilityAuthorization(
            allowedActions: ["test"]
        )

        XCTAssertTrue(
            registry.execute(
                SDKWebViewMessage(action: "test"),
                authorization: authorization
            )
        )
    }
    
    func test_registryDoesNotExecuteUnauthorizedCapability() {
        let registry = SDKCapabilityRegistry()
        let authorization = SDKCapabilityAuthorization(
            allowedActions: ["open"]
        )

        var wasExecuted = false

        registry.register(
            SDKCapabilityMock(action: "camera") { _ in
                wasExecuted = true
            }
        )

        let executed = registry.execute(
            SDKWebViewMessage(action: "camera"),
            authorization: authorization
        )

        XCTAssertFalse(executed)
        XCTAssertFalse(wasExecuted)
    }

}

private struct SDKCapabilityMock: SDKCapability {
    let action: String
    let handler: (SDKWebViewMessage) -> Void

    init(
        action: String,
        handler: @escaping (SDKWebViewMessage) -> Void)
    {
        self.action = action
        self.handler = handler
    }

    func execute(_ message: SDKWebViewMessage) {
        handler(message)
    }
}
