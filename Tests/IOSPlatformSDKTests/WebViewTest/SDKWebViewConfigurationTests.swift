//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import XCTest
@testable import IOSPlatformSDK

final class SDKWebViewConfigurationTest: XCTestCase {
    func test_confuguration_storesURL() {
        let url = URL(string: "https://example.com")!
        let configuration = SDKWebViewConfiguration(url: url)
        
        XCTAssertEqual(configuration.url, url)
    }
}
