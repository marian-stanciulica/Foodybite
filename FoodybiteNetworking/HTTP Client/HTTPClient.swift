//
//  HTTPClient.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

protocol HTTPClient {
    func get(for urlRequest: URLRequest) throws -> (data: Data, response: HTTPURLResponse)
}
