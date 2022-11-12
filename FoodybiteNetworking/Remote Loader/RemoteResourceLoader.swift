//
//  RemoteResourceLoader.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

class RemoteResourceLoader: ResourceLoader {
    private let client: HTTPClient
    private let codableDataParser = CodableDataParser()
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        guard let result = try? await client.send(urlRequest) else {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(result.response.statusCode) else {
            throw Error.invalidData
        }
        
        guard let decodable: T = try? codableDataParser.decode(data: result.data) else {
            throw Error.invalidData
        }
        
        return decodable
    }
    
    func post(to urlRequest: URLRequest) async throws {
        guard let result = try? await client.send(urlRequest) else {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(result.response.statusCode) else {
            throw Error.invalidData
        }
    }
}
