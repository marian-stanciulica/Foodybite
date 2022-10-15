//
//  CodableDataParser.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

class CodableDataParser {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
}
