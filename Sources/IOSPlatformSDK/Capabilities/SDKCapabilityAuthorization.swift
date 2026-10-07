//
// Copyright (c) 2026 Enjel Hutasoit
//

public struct SDKCapabilityAuthorization: Sendable {
    private let allowedActions: Set<String>

    public init(allowedActions: Set<String>) {
        self.allowedActions = allowedActions
    }

    public func isAllowed(
        _ message: SDKWebViewMessage
    ) -> Bool {
        allowedActions.contains(message.action)
    }
}
