//
// Copyright (c) 2026 Enjel Hutasoit
//

import Foundation


/// Performs authenticated SDK network requests using Apple's URLSession.
public final class SDKNetworkClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs a GET request and returns the response data.
    public func get(_ url: URL) async throws -> Data {
        guard url.scheme?.lowercased() == "https" else {
            throw SDKNetworkError.insecureURL
        }
        
        let (data, _) = try await session.data(from: url)
        
        return data
    }
}
