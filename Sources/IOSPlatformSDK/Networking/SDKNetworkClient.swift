//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation


/// Performs authenticated SDK network requests using Apple's URLSession.
public final class SDKNetworkClient {
    private let session: URLSession
    private let authenticator: SDKAuthenticator

    public init(
        session: URLSession = .shared,
        authenticator: SDKAuthenticator
    ) {
        self.session = session
        self.authenticator = authenticator
    }

    /// Builds a request with the current SDK access token.
    public func makeRequest(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)

        if let accessToken = authenticator.accessToken {
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }

        return request
    }

    /// Performs an authenticated GET request.
    public func get(_ url: URL) async throws -> Data {
        guard url.scheme?.lowercased() == "https" else {
            throw SDKNetworkError.insecureURL
        }

        guard authenticator.accessToken != nil else {
            throw SDKNetworkError.unauthenticated
        }

        let request = makeRequest(for: url)

        let (data, _) = try await session.data(for: request)

        return data
    }
}
