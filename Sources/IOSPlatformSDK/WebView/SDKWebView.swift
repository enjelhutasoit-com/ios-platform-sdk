//
// Copyright (c) 2026 Enjel Hutasoit
//

import SwiftUI
import WebKit

public struct SDKWebView: UIViewRepresentable {
    private let configuration: SDKWebViewConfiguration
    private let bridge: SDKWebViewBridge
    
    public init(
        configuration: SDKWebViewConfiguration,
        bridge: SDKWebViewBridge
    ) {
        self.configuration = configuration
        self.bridge = bridge
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        bridge.register(on: webView)
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        guard webView.url != configuration.url else { return }

        webView.load(.init(url: configuration.url))
    }
}
