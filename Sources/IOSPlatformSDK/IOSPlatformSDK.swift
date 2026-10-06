//
// Copyright (c) 2026 Enjel Hutasoit
//

public final class IOSPlatformSDK {
    public let configuration: SDKConfiguration
    public private(set) var state: SDKState = .idle

    public init(configuration: SDKConfiguration) {
        self.configuration = configuration
    }
    
    public func start() {
        state = .ready
    }
}
