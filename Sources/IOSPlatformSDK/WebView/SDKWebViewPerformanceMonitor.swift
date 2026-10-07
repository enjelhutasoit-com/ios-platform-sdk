//
// Copyright (c) 2026 Enjel Hutasoit
//

final class SDKWebViewPerformanceMonitor {
    private let logger: SDKLogger
    private var  startTime: ContinuousClock.Instant?
    
    init(logger: SDKLogger) {
        self.logger = logger
    }
    
    public func didStartNavigation() {
        startTime = ContinuousClock.now
    }
    
    public func didFinishNavigation() {
        guard let startTime else { return }
        
        let duration = startTime.duration(to: .now)
        
        logger.log(
            level: .info,
            message: "WebView navigation completed in \(duration)"
        )
        
        self.startTime = nil
    }
}
