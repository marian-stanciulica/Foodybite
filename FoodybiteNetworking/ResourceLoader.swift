//
//  ResourceLoader.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 29.03.2023.
//

import Foundation

public protocol ResourceLoader: Sendable {
    func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T
}
