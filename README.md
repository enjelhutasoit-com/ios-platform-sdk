# IOSPlatformSDK

A native Swift SDK demonstrating production-oriented iOS platform engineering patterns, including WebKit integration, JavaScript bridging, capability authorization, authenticated networking, API versioning, logging, and WebView performance instrumentation.

## Requirements

- iOS 16+
- Swift 6
- Xcode 16+

## Features

- SDK lifecycle management
- SwiftUI WebView component
- JavaScript-to-native bridge
- Structured WebView messages
- Message validation
- Native capability registry
- Capability authorization
- HTTPS enforcement
- Bearer-token authentication
- API versioning
- WebView performance instrumentation
- SDK logging abstraction
- WebView navigation failure handling
- XCTest coverage
- GitHub Actions CI
- Release-build validation

## Installation

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

## SDK Lifecycle

Create and start the SDK:

```swift
let sdk = IOSPlatformSDK(
    configuration: SDKConfiguration(
        environment: .development
    )
)

sdk.start()
```

The SDK starts in:

```swift
.idle
```

and transitions to:

```swift
.ready
```

after `start()`.

## WebView

Configure a WebView with a URL and JavaScript bridge:

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

`SDKWebView` is a SwiftUI `UIViewRepresentable` backed by `WKWebView`.

## JavaScript Bridge

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

The SDK validates the message and converts it to:

```swift
SDKWebViewMessage(
    action: "open",
    payload: [
        "screen": "profile"
    ]
)
```

Invalid messages, including messages without a valid action, are ignored.

## Capability Registry

Native capabilities can be registered with the SDK capability registry:

```swift
let registry = SDKCapabilityRegistry()

registry.register(
    MyCapability()
)
```

A capability defines the action it handles:

```swift
struct MyCapability: SDKCapability {
    let action = "open"

    func execute(_ message: SDKWebViewMessage) {
        // Handle the capability.
    }
}
```

## Capability Authorization

Capabilities require explicit authorization before execution:

```swift
let authorization = SDKCapabilityAuthorization(
    allowedActions: ["open"]
)
```

Execution requires the authorization object:

```swift
registry.execute(
    message,
    authorization: authorization
)
```

An action that is not authorized is not executed.

## Authentication

The SDK manages authentication state through `SDKAuthenticator`:

```swift
let authenticator = SDKAuthenticator()

authenticator.authenticate(
    accessToken: "your-access-token"
)
```

The authentication state becomes:

```swift
.authenticated
```

Signing out clears the access token:

```swift
authenticator.signOut()
```

## Networking

`SDKNetworkClient` uses Apple's `URLSession` and requires authentication:

```swift
let client = SDKNetworkClient(
    authenticator: authenticator
)
```

Only HTTPS URLs are accepted.

Authenticated requests include the access token as a Bearer token:

```text
Authorization: Bearer <access-token>
```

Unauthenticated requests are rejected before the network request is performed.

## API Versioning

Requests can specify the supported API contract:

```swift
let request = client.makeRequest(
    for: url,
    apiVersion: .v1
)
```

For example:

```text
https://example.com/orders
```

becomes:

```text
https://example.com/v1/orders
```

The API version is part of the SDK's client-server contract.

## Logging

The SDK provides an injectable logging abstraction:

```swift
let logger = SDKLogger()
```

Log levels currently include:

```swift
.debug
.info
.error
```

The base logger does not emit output by default. Host applications can provide their own logging implementation.

Sensitive credentials should never be included in log messages.

## WebView Performance

The SDK instruments WebView navigation timing internally.

Successful navigation reports its duration through `SDKLogger`.

Navigation failures are also reported at the `.error` level through the SDK logging abstraction.

The host application does not need to manage the underlying `WKNavigationDelegate`.

## Testing

The SDK uses XCTest and includes coverage for:

- SDK lifecycle
- WebView configuration
- JavaScript bridge
- Structured message parsing
- Capability registration
- Capability authorization
- Authentication lifecycle
- Network request construction
- HTTPS enforcement
- API versioning
- WebView hosting
- Logging
- WebView performance instrumentation

WebKit behavior is tested using real `WKWebView` instances rather than mocked WebKit message objects.

Tests must run against an iOS simulator because the SDK uses iOS frameworks such as WebKit and SwiftUI.

## Continuous Integration

GitHub Actions validates the SDK on macOS.

Normal CI:

- builds the SDK
- runs the XCTest suite

Release validation:

- builds using the Release configuration
- runs the XCTest suite
- can be triggered manually
- runs automatically for version tags matching `v*`

Release validation does not publish the SDK.

## Project Structure

```text
ios-platform-sdk/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       └── release-validation.yml
├── Sources/
│   └── IOSPlatformSDK/
│       ├── Authentication/
│       ├── Capabilities/
│       ├── Logging/
│       ├── Networking/
│       └── WebView/
├── Tests/
│   └── IOSPlatformSDKTests/
├── Documentation/
├── .gitignore
├── LICENSE
└── Package.swift
```

## Design Goals

The project focuses on native iOS platform engineering:

- public API design
- modular responsibilities
- explicit authorization
- backward-compatible message parsing
- authenticated client-server communication
- WebKit integration
- testability
- performance instrumentation
- operational diagnostics
- CI and release validation

The project is intentionally implemented with native Swift and Apple frameworks rather than cross-platform abstractions.

## Integration

See the [Integration Guide](Documentation/Integration.md) for detailed instructions on:

- SDK initialization
- WebView integration
- JavaScript bridge
- Capability authorization
- Authentication
- Networking
- API versioning
