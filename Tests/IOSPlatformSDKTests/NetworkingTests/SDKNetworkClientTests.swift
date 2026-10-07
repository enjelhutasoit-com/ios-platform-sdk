//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKNetworkClientTests: XCTestCase {
    func test_clientRejectsHTTPURL() async {
        guard let url = URL(string: "http://example.com") else {
            return XCTFail("Expected valid URL")
        }
        let authenticator = SDKAuthenticator()
        let client = SDKNetworkClient(
            authenticator: authenticator
        )
        
        do {
            _ = try await client.get(url)
            XCTFail("Expected insecure URL error")
        } catch let error as SDKNetworkError {
            XCTAssertEqual(error, .insecureURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_clientAcceptsHTTPSURL() async {
        guard let url = URL(string: "https://example.com") else {
            return XCTFail("Expected valid URL")
        }
        
        let authenticator = SDKAuthenticator()
        authenticator.authenticate(
            accessToken: "access-token"
        )

        let client = SDKNetworkClient(
            authenticator: authenticator
        )
        
        do {
            _ = try await client.get(url)
        } catch let error as SDKNetworkError {
            XCTAssertNotEqual(error, .insecureURL)
        } catch {
            // A network failure is acceptable here.
            // The test only verifies that HTTPS is not rejected as insecure.
        }
    }
    
    func test_clientRejectsUnauthenticatedRequest() async {
        guard let url = URL(string: "https://example.com") else {
            return XCTFail("Expected valid URL")
        }
                
        let client = SDKNetworkClient(
            authenticator: SDKAuthenticator()
        )
        
        do {
            _ = try await client.get(url)
            XCTFail("Expected authentication error")
        } catch let error as SDKNetworkError {
            XCTAssertEqual(error, .unauthenticated)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func test_clientCreatesBearerAuthorizationHeader() {
        let authenticator = SDKAuthenticator()
        
        authenticator.authenticate(
            accessToken: "access-token"
        )
        
        let client = SDKNetworkClient(
            authenticator: authenticator
        )
        
        let request = client.makeRequest(
            for: URL(string: "https://example.com")!
        )
        
        XCTAssertEqual(
            request.value(forHTTPHeaderField: "Authorization"),
            "Bearer access-token"
        )
    }
}
