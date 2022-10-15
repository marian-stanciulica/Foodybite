//
//  RemoteResourceLoader.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

class RemoteResourceLoader {
    private let client: HTTPClient
    private let codableDataParser = CodableDataParser()
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func get<T: Decodable>(for urlRequest: URLRequest) throws -> T {
        let result: (data: Data, response: HTTPURLResponse)
        
        do {
            result = try client.get(for: urlRequest)
        } catch {
            throw Error.connectivity
        }
        
        guard (200..<300).contains(result.response.statusCode) else {
            throw Error.invalidData
        }
        
        do {
            return try codableDataParser.decode(data: result.data)
        } catch {
            throw Error.invalidData
        }
    }
}
