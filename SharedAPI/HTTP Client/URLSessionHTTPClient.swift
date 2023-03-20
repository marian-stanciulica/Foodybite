//
//  URLSessionHTTPClient.swift
//  SharedAPI
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    struct UnexpectedRepresentation: Error {}
    
    public func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let (data, response) = try await session.data(for: urlRequest, delegate: nil)
        
        guard let response = response as? HTTPURLResponse else {
            throw UnexpectedRepresentation()
        }
        
        return (data, response)
    }
}
