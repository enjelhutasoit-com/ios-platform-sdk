//
// Copyright (c) 2026 Enjel Hutasoit
//

import XCTest
@testable import IOSPlatformSDK

final class SDKLoggerTests: XCTestCase {
    func test_logger_recordsMessage() {
        let logger = SDKLoggerMock()
        
        logger.log(
            level: .info,
            message: "SDK started"
        )
        
        XCTAssertEqual(
            logger.entries,
            [
                .init(
                    level: .info,
                    message: "SDK started"
                )
            ]
        )
    }    
}

private final class SDKLoggerMock: SDKLogger {
    struct Entry: Equatable {
        let level: SDKLogLevel
        let message: String
    }

    private(set) var entries: [Entry] = []

    override func log(
        level: SDKLogLevel,
        message: String
    ) {
        entries.append(
            Entry(
                level: level,
                message: message
            )
        )
    }
}
