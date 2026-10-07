//
// Copyright (c) 2026 Enjel Hutasoit
//

/// Provides logging without coupling the SDK to a logging framework.
open class SDKLogger {
    public init() {}
    
    /// Records a diagnostic message.
    open func log(
        level: SDKLogLevel,
        message: String
    ) {
        // Intentionally empty.
        // Host applications can provide their own logger.
    }
}
