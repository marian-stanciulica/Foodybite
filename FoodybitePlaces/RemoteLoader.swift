//
//  RemoteResourceLoader.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

public class RemoteLoader: ResourceLoader, DataLoader {
    private let client: HTTPClient
    private let codableDataParser = CodableDataParser()
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T {
        let data = try await getData(for: urlRequest)
        
        guard let decodable: T = try? codableDataParser.decode(data: data) else {
            throw Error.invalidData
        }
        
        return decodable
    }
    
    public func getData(for urlRequest: URLRequest) async throws -> Data {
        guard let result = try? await client.send(urlRequest) else {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(result.response.statusCode) else {
            throw Error.invalidData
        }
        
        return result.data
    }
    
}
