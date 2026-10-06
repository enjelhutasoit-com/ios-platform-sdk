//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import WebKit
@testable import IOSPlatformSDK

final class SDKWebViewBridgeTests: XCTestCase {
    @MainActor
    func test_bridge_receivesStructuredMessage() {
        let expectation = expectation(
            description: "Bridge receives message"
        )

        let bridge = SDKWebViewBridge { message in
            XCTAssertEqual(message.action, "open")
            XCTAssertEqual(
                message.payload,
                ["screen": "profile"]
            )
            expectation.fulfill()
        }

        let webView = WKWebView()
        bridge.register(on: webView)

        webView.loadHTMLString(
            """
            <script>
                window.webkit.messageHandlers.iosPlatform.postMessage({
                    action: "open",
                    payload: {
                        screen: "profile"
                    }
                });
            </script>
            """,
            baseURL: nil
        )

        wait(for: [expectation], timeout: 5)
    }

    @MainActor
    func test_bridge_canBeUnregistered() {
        let bridge = SDKWebViewBridge()
        let webView = WKWebView()

        bridge.register(on: webView)
        bridge.unregister(from: webView)

        XCTAssertNotNil(webView)
    }
}
