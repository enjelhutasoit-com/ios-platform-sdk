//
// Copyright (c) 2026 Enjel Hutasoit
//

public struct SDKConfiguration: Sendable {
    public let environment: Environment

    public init(environment: Environment) {
        self.environment = environment
    }
}

public enum Environment: Sendable {
    case development
    case production
}
