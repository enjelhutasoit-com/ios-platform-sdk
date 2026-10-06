//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKWebViewMessageParserTests: XCTestCase {
    func test_parser_createsMessageFromValidBody() {
        let parser = SDKWebViewMessageParser()
        
        let message = parser.parse([
            "action": "open",
            "payload": ["screen" : "profile"]
        ])
        
        XCTAssertEqual(
            message,
            SDKWebViewMessage(
                action: "open",
                payload: ["screen" : "profile"]
            )
        )
    }
    
    func test_parserRejectsMissingAction() {
        let parser = SDKWebViewMessageParser()
        
        let message = parser.parse([
            "payload": [
                "screen": "profile"
            ]
        ])
        
        XCTAssertNil(message)
    }
    
    func test_parserRejectsEmptyAction() {
        let parser = SDKWebViewMessageParser()
        
        let message = parser.parse([
            "action": ""
        ])
        
        XCTAssertNil(message)
    }
}
