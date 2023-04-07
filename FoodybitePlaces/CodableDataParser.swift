//
//  CodableDataParser.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 29.03.2023.
//

import Foundation

class CodableDataParser {
    private let jsonDecoder = JSONDecoder()

    func decode<T: Decodable>(data: Data) throws -> T {
        jsonDecoder.dateDecodingStrategy = .iso8601
        return try jsonDecoder.decode(T.self, from: data)
    }
}
