//
//  URLSessionHTTPClient.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

class URLSessionHTTPClient: HTTPClient {
    private let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    struct UnexpectedRepresentation: Error {}
    
    func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let (data, response) = try await urlSession.data(for: urlRequest, delegate: nil)
        
        guard let response = response as? HTTPURLResponse else {
            throw UnexpectedRepresentation()
        }
        
        return (data, response)
    }
}
