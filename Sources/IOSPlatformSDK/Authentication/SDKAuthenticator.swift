//
// Copyright (c) 2026 Enjel Hutasoit
//

public final class SDKAuthenticator {
    public private(set) var state: SDKAuthenticatorState = .unauthenticated
    public private(set) var accessToken: String?
    
    public init() {}
    
    /// Starts an authenticated SDK session with an access token.
    public func authenticate(accessToken: String) {
        self.accessToken = accessToken
        state = .authenticated
    }
    
    /// Ends the current SDK authentication session.
    public func signOut() {
        accessToken = nil
        state = .unauthenticated
    }

}
