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

        registry.execute(message)

        XCTAssertEqual(receivedMessage, message)
    }

    func test_registryIgnoresUnregisteredCapability() {
        let registry = SDKCapabilityRegistry()

        XCTAssertFalse(
            registry.execute(
                SDKWebViewMessage(action: "unknown")
            )
        )
    }

    func test_registryReturnsTrueWhenCapabilityExecutes() {
        let registry = SDKCapabilityRegistry()

        registry.register(
            SDKCapabilityMock(action: "test") { _ in }
        )

        XCTAssertTrue(
            registry.execute(
                SDKWebViewMessage(action: "test")
            )
        )
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
