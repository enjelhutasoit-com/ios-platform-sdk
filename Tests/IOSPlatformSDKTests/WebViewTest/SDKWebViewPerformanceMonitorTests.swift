//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class  SDKWebViewPerformanceMonitorTests: XCTestCase {
    func test_monitor_reportsPageLoadDuration() {
        let logger = SDKLoggerMock()
        let monitor = SDKWebViewPerformanceMonitor(logger: logger)
        
        monitor.didStartNavigation()
        monitor.didFinishNavigation()
        
        XCTAssertEqual(logger.entries.count, 1)
        XCTAssertEqual(logger.entries.first?.level, .info)
        XCTAssertTrue(logger.entries.first?.message.contains("WebView navigation completed") == true )
    }
}
