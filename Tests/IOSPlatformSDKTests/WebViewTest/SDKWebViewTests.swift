//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
import WebKit
@testable import IOSPlatformSDK

final class SDKWebViewTests: XCTestCase {
    @MainActor func test_webview_canBeCreated() {
        let webView = WKWebView()
        
        XCTAssertNotNil(webView)
    }
}
