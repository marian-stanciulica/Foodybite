//
//  ResourceLoader.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

protocol ResourceLoader {
    func get<T: Decodable>(from endpoint: Endpoint) throws -> T
}
