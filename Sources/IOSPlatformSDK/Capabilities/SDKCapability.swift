//
// Copyright (c) 2026 Enjel Hutasoit
//

public protocol SDKCapability {
    var action: String { get }

    func execute(_ message: SDKWebViewMessage)
}
