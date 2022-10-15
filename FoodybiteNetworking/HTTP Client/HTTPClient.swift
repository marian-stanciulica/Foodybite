//
//  HTTPClient.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

protocol HTTPClient {
    func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
