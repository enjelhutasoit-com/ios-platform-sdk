//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation

public struct SDKWebViewConfiguration: Sendable, Equatable {
    public let url: URL
    
    public init(url: URL) {
        self.url = url
    }
}
