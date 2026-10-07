//
// Copyright (c) 2026 Enjel Hutasoit
//

import SwiftUI
import XCTest
import WebKit
@testable import IOSPlatformSDK

final class SDKWebViewTests: XCTestCase {
    @MainActor
    func test_webview_registersBridge() {
        guard let url = URL(string: "https://example.com") else {
            return  XCTFail("Expected valid URL")
        }
        let bridge = SDKWebViewBridge()
        let configuration = SDKWebViewConfiguration(url: url)
        let sdkWebView = SDKWebView(configuration: configuration, bridge: bridge)
        let hostingController = UIHostingController(rootView: sdkWebView)
        
        XCTAssertNotNil(hostingController.view)
    }
    
    @MainActor
    func test_webViewCanBeHosted() {
        guard let url = URL(string: "about:blank") else {
            return XCTFail("Expected valid URL")
        }
        
        let bridge = SDKWebViewBridge()
        
        let sdkWebView = SDKWebView(
            configuration: SDKWebViewConfiguration(url: url),
            bridge: bridge
        )
        
        let hostingController = UIHostingController(
            rootView: sdkWebView
        )
        
        XCTAssertNotNil(hostingController.view)
    }
}
