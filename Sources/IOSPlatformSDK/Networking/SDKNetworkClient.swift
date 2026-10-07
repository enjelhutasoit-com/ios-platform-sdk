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

    /// Builds an authenticated request for the specified API version.
    public func makeRequest(
        for url: URL,
        apiVersion: SDKAPIVersion
    ) -> URLRequest {
        var components = URLComponents(
            url: url,
            resolvingAgainstBaseURL: false
        )
        
        let versionPath = "/\(apiVersion.rawValue)"
        
        if let path = components?.path {
            components?.path = versionPath + path
        }

        var request = URLRequest(url: components?.url ?? url)

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

        let request = makeRequest(
            for: url,
            apiVersion: .v1
        )

        let (data, _) = try await session.data(for: request)

        return data
    }
}
