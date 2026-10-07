# SDK Integration Guide

## Requirements

- iOS 16+
- Swift 6
- Xcode 16+

## Add the SDK

Add `IOSPlatformSDK` as a Swift Package dependency.

For local development:

```swift
.package(
    path: "../ios-platform-sdk"
)
```

Then import the SDK:

```swift
import IOSPlatformSDK
```

## Initialize the SDK

Create the SDK with an environment configuration:

```swift
let sdk = IOSPlatformSDK(
    configuration: SDKConfiguration(
        environment: .development
    )
)

sdk.start()
```

The SDK starts in `.idle` and transitions to `.ready` after `start()`.

## Present a WebView

Configure the URL and bridge:

```swift
guard let url = URL(string: "https://example.com") else {
    return
}

let configuration = SDKWebViewConfiguration(
    url: url
)

let bridge = SDKWebViewBridge { message in
    print(message.action)
    print(message.payload)
}

let webView = SDKWebView(
    configuration: configuration,
    bridge: bridge
)
```

`SDKWebView` can then be embedded in a SwiftUI view hierarchy.

## JavaScript bridge

The default JavaScript handler name is:

```text
iosPlatform
```

JavaScript can send a structured message:

```javascript
window.webkit.messageHandlers.iosPlatform.postMessage({
    action: "open",
    payload: {
        screen: "profile"
    }
});
```

The SDK converts this into:

```swift
SDKWebViewMessage(
    action: "open",
    payload: [
        "screen": "profile"
    ]
)
```

## Capability authorization

Capabilities must be explicitly authorized before execution:

```swift
let authorization = SDKCapabilityAuthorization(
    allowedActions: ["open"]
)
```

The registry only executes a capability when its action is authorized.

## Network authentication

The SDK authenticator manages the current access token:

```swift
let authenticator = SDKAuthenticator()

authenticator.authenticate(
    accessToken: "your-access-token"
)
```

The network client uses the authenticated token when creating requests.

Do not log access tokens or other sensitive credentials.

## API versioning

Network requests can specify the supported API contract:

```swift
let request = client.makeRequest(
    for: url,
    apiVersion: .v1
)
```

The SDK adds the API version to the request path.

## Security

The SDK:

- requires HTTPS for network requests
- rejects unauthenticated network requests
- uses Bearer authentication
- requires explicit capability authorization
- avoids logging access tokens
```
