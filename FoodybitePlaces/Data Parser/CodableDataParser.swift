//
//  CodableDataParser.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

class CodableDataParser {
    private let jsonDecoder = JSONDecoder()
    
    func decode<T: Decodable>(data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
}
