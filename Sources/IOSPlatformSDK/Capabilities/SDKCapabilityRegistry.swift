//
// Copyright (c) 2026 Enjel Hutasoit
//

public final class SDKCapabilityRegistry {
    private var capabilities: [String: any SDKCapability] = [:]
    
    public init() {}
    
    public func register(_ capability: any SDKCapability) {
        capabilities[capability.action] = capability
    }
    
    @discardableResult
    public func execute(
        _ message: SDKWebViewMessage,
        authorization: SDKCapabilityAuthorization
    ) -> Bool {
        guard authorization.isAllowed(message),
            let capability = capabilities[message.action] else {
            return false
        }
        
        capability.execute(message)
        return true
    }
}
