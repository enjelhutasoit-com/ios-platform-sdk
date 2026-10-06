//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class IOSPlatformSDKTests: XCTestCase {
    func test_SDK_startsInIdleState() {
        let sdk = makeSDK()
                
        XCTAssertEqual(sdk.state, .idle)
    }
    
    func test_SDK_becomesReadyAfterStarting() {
        let sdk = makeSDK()
        
        sdk.start()
        
        XCTAssertEqual(sdk.state, .ready)
    }
    
    // MARK: - Helpers
    
    private func makeSDK() -> IOSPlatformSDK {
        IOSPlatformSDK(
            configuration: .init(environment: .development)
        )
    }
}
