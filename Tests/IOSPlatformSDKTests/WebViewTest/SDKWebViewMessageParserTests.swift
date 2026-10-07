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
    
    func test_parserAcceptsMessageWithoutPayload() {
        let parser = SDKWebViewMessageParser()
        
        let message = parser.parse([
            "action": "open"
        ])
        
        XCTAssertEqual(
            message,
            SDKWebViewMessage(
                action: "open",
                payload: [:]
            )
        )
    }
    
    func test_parserIgnoresUnknownFields() {
        let parser = SDKWebViewMessageParser()
        
        let message = parser.parse([
            "action": "open",
            "payload": [
                "screen": "profile"
            ],
            "version": "legacy",
            "unknownField": "ignored"
        ])
        
        XCTAssertEqual(
            message,
            SDKWebViewMessage(
                action: "open",
                payload: ["screen": "profile"]
            )
        )
    }
}
