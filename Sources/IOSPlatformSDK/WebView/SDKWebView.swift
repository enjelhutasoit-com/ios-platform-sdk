//
// Copyright (c) 2026 Enjel Hutasoit
//

import SwiftUI
import WebKit

public struct SDKWebView: UIViewRepresentable {
    private let configuration: SDKWebViewConfiguration

    public init(configuration: SDKWebViewConfiguration) {
        self.configuration = configuration
    }

    public func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        guard webView.url != configuration.url else { return }

        webView.load(.init(url: configuration.url))
    }
}
