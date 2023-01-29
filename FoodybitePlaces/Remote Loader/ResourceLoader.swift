//
//  ResourceLoader.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

public protocol ResourceLoader {
    func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T
    func getData(for urlRequest: URLRequest) async throws -> Data
}
