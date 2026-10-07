//
// Copyright (c) 2026 Enjel Hutasoit
//

import WebKit

final class SDKWebViewNavigationDelegate: NSObject, WKNavigationDelegate {
    private let logger: SDKLogger
    
    init(logger: SDKLogger) {
        self.logger = logger
    }
    
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation?,
        withError error: Error
    ) {
        logger.log(
            level: .error,
            message: "WebView navigation failed: \(error.localizedDescription)"
        )
    }
    
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation?,
        withError error: Error
    ) {
        logger.log(
            level: .error,
            message: "WebView provisional navigation failed: \(error.localizedDescription)"
        )
    }
}
