//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation

struct SDKWebViewMessageParser {
    func parse(_ body: Any) -> SDKWebViewMessage? {
        guard let body = body as? [String: Any],
              let action = body["action"] as? String,
              !action.isEmpty else {
            return nil
        }
        
        let payload = body["payload"] as? [String: String] ?? [:]
        
        return SDKWebViewMessage(
            action: action,
            payload: payload
        )
    }
}
