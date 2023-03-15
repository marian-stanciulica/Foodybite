//
//  URLSessionHTTPClient.swift
//  SharedAPI
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let urlSession: URLSessionProtocol
    
    public init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    struct UnexpectedRepresentation: Error {}
    
    public func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let (data, response) = try await urlSession.data(for: urlRequest, delegate: nil)
        
        guard let response = response as? HTTPURLResponse else {
            throw UnexpectedRepresentation()
        }
        
        return (data, response)
    }
}
