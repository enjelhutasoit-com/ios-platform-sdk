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
        guard message.name == handlerName,
              let body = message.body as? [String: Any],
              let action = body["action"] as? String else {
            return
        }

        let payload = body["payload"] as? [String: String] ?? [:]

        messageHandler?(
            SDKWebViewMessage(
                action: action,
                payload: payload
            )
        )
    }
}
