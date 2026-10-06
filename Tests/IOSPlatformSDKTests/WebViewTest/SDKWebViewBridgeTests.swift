//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import WebKit
@testable import IOSPlatformSDK

final class SDKWebViewBridgeTests: XCTestCase {
    @MainActor
    func test_bridge_receivesJavaScriptMessage() {
        let expectation = expectation(description: "Bridge receives message")

        let bridge = SDKWebViewBridge { name, body in
            XCTAssertEqual(name, "iosPlatform")
            XCTAssertEqual(body as? String, "open")
            expectation.fulfill()
        }

        let webView = WKWebView()
        bridge.register(on: webView)

        webView.loadHTMLString(
            """
            <html>
                <body>
                    <script>
                        window.webkit.messageHandlers.iosPlatform.postMessage("open");
                    </script>
                </body>
            </html>
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
