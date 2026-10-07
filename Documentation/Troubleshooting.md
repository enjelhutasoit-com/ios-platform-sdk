# Troubleshooting

This guide covers common issues when integrating or diagnosing `IOSPlatformSDK`.

## WebView Does Not Load

### Check the URL

The SDK WebView requires a valid URL.

```swift
guard let url = URL(string: "https://example.com") else {
    return
}
```

### Check navigation errors

WebView navigation failures are reported through `SDKLogger` at the `.error` level.

Check the logger implementation supplied by the host application.

## JavaScript Message Is Not Received

Verify that JavaScript uses the SDK's registered handler name.

The default handler name is:

```text
iosPlatform
```

Example:

```javascript
window.webkit.messageHandlers.iosPlatform.postMessage({
    action: "open",
    payload: {
        screen: "profile"
    }
});
```

Also verify that the message contains a non-empty `action`.

Messages without a valid action are rejected by the message parser.

## Capability Is Not Executed

There are two requirements:

1. A capability with the matching action must be registered.
2. The action must be authorized.

For example:

```swift
let authorization = SDKCapabilityAuthorization(
    allowedActions: ["open"]
)
```

An action not included in `allowedActions` is rejected before execution.

## Network Request Is Rejected

### HTTP URL

The SDK only accepts HTTPS URLs.

```text
http://example.com
```

is rejected.

Use:

```text
https://example.com
```

### Missing authentication

The network client requires an authenticated SDK session.

Authenticate first:

```swift
let authenticator = SDKAuthenticator()

authenticator.authenticate(
    accessToken: "your-access-token"
)
```

Then create the network client:

```swift
let client = SDKNetworkClient(
    authenticator: authenticator
)
```

## API Version Is Unexpected

The SDK currently supports:

```swift
SDKAPIVersion.v1
```

A request such as:

```text
https://example.com/orders
```

is constructed as:

```text
https://example.com/v1/orders
```

when `.v1` is supplied.

Verify that the server endpoint matches the selected API contract.

## Authentication State Is Unexpected

`SDKAuthenticator` starts in:

```swift
.unauthenticated
```

Calling:

```swift
authenticator.authenticate(
    accessToken: "your-access-token"
)
```

changes the state to:

```swift
.authenticated
```

Calling:

```swift
authenticator.signOut()
```

clears the access token and returns the state to `.unauthenticated`.

## Performance Diagnostics

WebView navigation timing is recorded by the SDK's performance instrumentation.

The timing is reported through `SDKLogger` at the `.info` level after successful navigation.

Use the host application's logger implementation to inspect these messages.

## Logging

The default `SDKLogger` does not emit output.

If diagnostics are required, provide a host-specific logging implementation.

Do not include:

- access tokens
- credentials
- cookies
- other sensitive authentication data

in log messages.

## CI Failures

The SDK CI runs against an iOS Simulator.

If a local test passes on macOS but fails when using an iOS runtime, verify that the test is being executed against an iOS Simulator rather than a macOS test destination.

The release-validation workflow additionally builds and tests the SDK using the `Release` configuration.

## Diagnostic Checklist

When investigating an SDK issue:

1. Confirm the SDK configuration.
2. Confirm the SDK lifecycle state.
3. Check WebView navigation errors.
4. Check JavaScript handler names.
5. Check message structure.
6. Check capability registration.
7. Check capability authorization.
8. Check authentication state.
9. Check HTTPS and API versioning.
10. Inspect SDK logs.

If the issue crosses a component boundary, reproduce it with the smallest possible integration before changing SDK internals.
