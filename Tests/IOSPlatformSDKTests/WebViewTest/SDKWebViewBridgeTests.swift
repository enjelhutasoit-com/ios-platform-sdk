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
    
    @MainActor
    func test_bridge_sendsMessageToJavaScript() {
        let pageLoaded = expectation(description: "Page loaded")
        
        let webView = WKWebView()
        let navigationDelegate = TestNavigationDelegate {
            pageLoaded.fulfill()
        }
        
        webView.navigationDelegate = navigationDelegate
        
        webView.loadHTMLString(
                    """
                    <script>
                        window.receivedMessage = null;
                    
                        window.addEventListener(
                            'iosPlatformMessage',
                            function(event) {
                                window.receivedMessage = event.detail;
                            }
                        );
                    </script>
                    """,
                    baseURL: nil
        )
        
        wait(for: [pageLoaded], timeout: 5)
        
        let bridge = SDKWebViewBridge()
        
        bridge.send(
            action: "open",
            payload: ["screen": "profile"],
            to: webView
        )
        
        let messageReceived = expectation(description: "JavaScript receives message")
        
        webView.evaluateJavaScript(
            "JSON.stringify(window.receivedMessage)"
        ) { result, error in
            XCTAssertNil(error)

            guard let json = result as? String,
                  let data = json.data(using: .utf8),
                  let message = try? JSONSerialization.jsonObject(
                    with: data
                ) as? [String: Any] else {
                return XCTFail("Expected JavaScript message")
            }

            XCTAssertEqual(message["action"] as? String, "open")
            XCTAssertEqual(
                message["payload"] as? [String: String],
                ["screen": "profile"]
            )

            messageReceived.fulfill()
        }

        wait(for: [messageReceived], timeout: 5)
    }
    
    @MainActor
    func test_bridge_dispatchesMessageToCapabilityRegistry() {
        let expectation = expectation(
            description: "Capability receives message"
        )
        
        let registry = SDKCapabilityRegistry()
        
        registry.register(
            BridgeCapabilityMock {
                expectation.fulfill()
            }
        )
        
        let authorization = SDKCapabilityAuthorization(
            allowedActions: ["open"]
        )

        let bridge = SDKWebViewBridge { message in
            _ = registry.execute(message, authorization: authorization)
        }
        
        let webView = WKWebView()
        bridge.register(on: webView)
        
        webView.loadHTMLString(
            """
            <script>
                window.webkit.messageHandlers.iosPlatform.postMessage({
                    action: "open",
                    payload: {}
                });
            </script>
            """,
            baseURL: nil
        )
        
        wait(for: [expectation], timeout: 5)
    }
}


@MainActor
private final class TestNavigationDelegate: NSObject, WKNavigationDelegate {
    private let onFinish: () -> Void
    
    init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation?
    ) {
        onFinish()
    }
}

private struct BridgeCapabilityMock: SDKCapability {
    let action: String = "open"
    let handler: () -> Void

    init(handler: @escaping () -> Void) {
        self.handler = handler
    }

    func execute(_ message: SDKWebViewMessage) {
        handler()
    }
}
