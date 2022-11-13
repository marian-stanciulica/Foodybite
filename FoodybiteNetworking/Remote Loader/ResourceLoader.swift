//
//  ResourceLoader.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation

public protocol ResourceLoader {
    func get<T: Decodable>(for urlRequest: URLRequest) async throws -> T
}
