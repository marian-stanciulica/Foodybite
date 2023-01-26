//
//  RemoteResourceLoader.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

public class RemoteResourceLoader: ResourceLoader, ResourceSender {
    private let client: HTTPClient
    private let codableDataParser = CodableDataParser()
    
    enum Error: Swift.Error {
        case connectivity
        case invalidRequest
        case invalidData
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        guard let result = try? await client.send(urlRequest) else {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(result.response.statusCode) else {
            throw Error.invalidRequest
        }
        
        guard let decodable: T = try? codableDataParser.decode(data: result.data) else {
            throw Error.invalidData
        }
        
        return decodable
    }
    
    public func post(to urlRequest: URLRequest) async throws {
        guard let result = try? await client.send(urlRequest) else {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(result.response.statusCode) else {
            throw Error.invalidRequest
        }
    }
}
