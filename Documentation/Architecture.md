# Architecture

## Overview

`IOSPlatformSDK` is organized around independent responsibilities:

```text
Host Application
       │
       ▼
IOSPlatformSDK
       │
       ├── Lifecycle
       │
       ├── WebView
       │    ├── SDKWebView
       │    ├── SDKWebViewBridge
       │    ├── Message Parser
       │    ├── Capability Registry
       │    ├── Authorization
       │    ├── Navigation Delegate
       │    └── Performance Monitor
       │
       ├── Authentication
       │
       ├── Networking
       │
       └── Logging
```

The SDK keeps platform responsibilities separated so individual components can be tested and evolved independently.

## WebView Message Flow

```text
JavaScript
    │
    │ postMessage(...)
    ▼
WKWebView
    │
    ▼
SDKWebViewBridge
    │
    ▼
SDKWebViewMessageParser
    │
    │ valid message
    ▼
SDKWebViewMessage
    │
    ▼
SDKCapabilityRegistry
    │
    ▼
SDKCapabilityAuthorization
    │
    │ authorized
    ▼
SDKCapability
```

Invalid messages are rejected by the parser.

Unauthorized actions are rejected by the capability registry before capability execution.

## Capability Contract

Capabilities expose an action identifier and an execution function:

```swift
public protocol SDKCapability {
    var action: String { get }

    func execute(
        _ message: SDKWebViewMessage
    )
}
```

The registry maps actions to capabilities.

```text
"open" ───────► OpenCapability
"share" ──────► ShareCapability
```

The action is therefore the contract between the incoming WebView message and the native capability.

## Authorization

Authorization is evaluated before capability execution:

```text
Incoming Message
       │
       ▼
Is action authorized?
   │           │
  No          Yes
   │           │
   ▼           ▼
Reject      Find capability
               │
               ▼
            Execute
```

This prevents a registered capability from being executed solely because its action exists.

## Networking

The networking layer uses Apple's `URLSession`.

```text
SDKNetworkClient
       │
       ├── HTTPS validation
       │
       ├── Authentication state
       │
       ├── API version
       │
       ▼
   URLRequest
       │
       ▼
    URLSession
```

The access token is supplied by `SDKAuthenticator`.

Requests include the API version as part of the request path.

For example:

```text
https://example.com/orders
            │
            ▼
https://example.com/v1/orders
```

## Authentication

Authentication state is owned by `SDKAuthenticator`.

```text
SDKAuthenticator
       │
       ├── unauthenticated
       │
       └── authenticated
             │
             └── access token
```

The network client reads the current authentication state when constructing requests.

## WebView Observability

WebView navigation is observed internally.

```text
WKWebView
   │
   ├── navigation started
   │        │
   │        ▼
   │   Performance Monitor
   │
   └── navigation finished/failed
            │
            ▼
        SDKLogger
```

Successful navigation reports timing information.

Navigation failures are reported as error-level log messages.

## Logging

Logging is exposed through the SDK's logging abstraction rather than a third-party logging framework.

```text
SDK Component
      │
      ▼
  SDKLogger
      │
      ▼
Host-provided logging implementation
```

The default logger does not emit output.

Sensitive credentials should not be included in log messages.

## Testing Strategy

The SDK uses several testing levels:

### Unit tests

Pure components such as message parsing, authorization, authentication, and request construction are tested without WebKit.

### WebKit integration tests

Actual `WKWebView` instances are used for JavaScript bridge behavior.

This avoids attempting to construct or subclass WebKit message objects that are controlled by the framework.

### Hosting tests

`SDKWebView` is tested to ensure the public SwiftUI component can be hosted.

## API Design Principles

The SDK follows these principles:

1. Keep public APIs small.
2. Separate responsibilities by component.
3. Prefer native Apple frameworks.
4. Make security decisions explicit.
5. Keep host applications independent from internal WebKit implementation details.
6. Make dependencies injectable where testing benefits from it.
7. Reject invalid or unauthorized input early.
8. Preserve compatibility when extending message contracts.

## Current Scope

The current implementation focuses on:

- SDK lifecycle
- WebView integration
- JavaScript bridging
- capability registration and authorization
- authenticated networking
- API versioning
- logging
- WebView performance instrumentation
- WebView failure handling
- automated testing
- CI and release validation

This document describes the current implementation rather than future architecture.
