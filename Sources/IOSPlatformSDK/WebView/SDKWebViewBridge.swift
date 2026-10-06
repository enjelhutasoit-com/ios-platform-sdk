//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import WebKit

@MainActor
public final class SDKWebViewBridge: NSObject {
    private let handlerName: String
    
    public init(handlerName: String = "iosPlatform") {
        self.handlerName = handlerName
    }
    
    public func register(on webView: WKWebView) {
        webView.configuration.userContentController.add(
            self,
            name: handlerName
        )
    }
    
    public func unregister(from webView: WKWebView) {
        webView.configuration.userContentController.removeScriptMessageHandler(
            forName: handlerName
        )
    }
}

extension SDKWebViewBridge: WKScriptMessageHandler {
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        // Message handling will be added in a later commit.
    }
}
