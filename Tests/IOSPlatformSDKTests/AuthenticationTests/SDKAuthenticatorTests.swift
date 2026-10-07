//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKAuthenticatorTests: XCTestCase {
    func test_authenticator_startsUnauthenticated() {
        let  authenticator = SDKAuthenticator()
        
        XCTAssertEqual(authenticator.state, .unauthenticated)
    }
    
    func test_authenticator_becomesAuthenticated() {
        let authenticator = SDKAuthenticator()
        
        authenticator.authenticate(accessToken: "access-token")
        
        XCTAssertEqual(authenticator.state, .authenticated)
    }
    
    func test_authenticator_exposesAccessToken_whenAuthenticated() {
        let authenticator = SDKAuthenticator()

        authenticator.authenticate(accessToken: "access-token")
        
        XCTAssertEqual(authenticator.accessToken, "access-token")
    }
    
    func test_authenticator_becomesUnauthenticated_afterSignOut() {
        let authenticator = SDKAuthenticator()

        authenticator.authenticate(accessToken: "access-token")

        authenticator.signOut()
        
        XCTAssertEqual(authenticator.state, .unauthenticated)
    }
}
