//
//  CodableDataParser.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

public class CodableDataParser {
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()
    
    public init() {}
    
    public func decode<T: Decodable>(data: Data) throws -> T {
        jsonDecoder.dateDecodingStrategy = .iso8601
        return try jsonDecoder.decode(T.self, from: data)
    }
    
    public func encode<T: Encodable>(item: T) throws -> Data {
        try jsonEncoder.encode(item)
    }
}
