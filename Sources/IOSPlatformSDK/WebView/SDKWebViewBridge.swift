//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation
import WebKit

@MainActor
public final class SDKWebViewBridge: NSObject {
    public typealias MessageHandler = @MainActor (
        _ message: SDKWebViewMessage
    ) -> Void
    
    private let parser = SDKWebViewMessageParser()
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
    
    public func send(
        action: String,
        payload: [String: String],
        to webView: WKWebView
    ) {
        let message: [String: Any] = [
            "action": action,
            "payload": payload
        ]
        
        guard
            let data = try? JSONSerialization.data(
                withJSONObject: message
            ),
            let json = String(data: data, encoding: .utf8)
        else {
            return
        }
        
        let script = """
        window.dispatchEvent(
            new CustomEvent('iosPlatformMessage', {
                detail: \(json)
            })
        );
        """
        
        webView.evaluateJavaScript(script)
    }
}

extension SDKWebViewBridge: WKScriptMessageHandler {
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == handlerName,
              let webViewMessage = parser.parse(message.body) else {
            return
        }

        messageHandler?(webViewMessage)
    }
}
