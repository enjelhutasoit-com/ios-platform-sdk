//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class IOSPlatformSDKTests: XCTestCase {
    func testSDKUsesProvidedConfiguration() {
        let configuration = SDKConfiguration(environment: .development)
        let sdk = IOSPlatformSDK(configuration: configuration)

        XCTAssertEqual(sdk.configuration.environment, .development)
    }
}
