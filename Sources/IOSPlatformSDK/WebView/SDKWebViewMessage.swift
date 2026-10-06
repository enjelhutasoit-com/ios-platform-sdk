//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation

public struct SDKWebViewMessage: Sendable, Equatable {
    public let action: String
    public let payload: [String: String]

    public init(
        action: String,
        payload: [String: String] = [:]
    ) {
        self.action = action
        self.payload = payload
    }
}
