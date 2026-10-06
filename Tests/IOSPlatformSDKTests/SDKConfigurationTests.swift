//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKConfigurationTEsts: XCTestCase {
    func test_configuration_storesEnvironment() {
        let configuration = SDKConfiguration(environment: .development)
            
        XCTAssertEqual(configuration.environment, .development)
    }
}
