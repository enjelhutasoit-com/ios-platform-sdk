//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import WebKit

@MainActor
public final class SDKWebViewBridge: NSObject {
    public typealias MessageHandler = @MainActor (
        _ name: String,
        _ body: Any
    ) -> Void
    
    private let handlerName: String
    private let messageHandler: MessageHandler?
    
    public init(
        handlerName: String = "iosPlatform",
        messageHandler: MessageHandler? = nil
    ) {
        self.handlerName = handlerName
        self.messageHandler = messageHandler
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
        guard message.name == handlerName else {
            return
        }
        
        messageHandler?(message.name, message.body)
    }
}
