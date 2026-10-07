//
// Copyright (c) 2026 Enjel Hutasoit
//

@testable import IOSPlatformSDK

final class SDKLoggerMock: SDKLogger {
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
