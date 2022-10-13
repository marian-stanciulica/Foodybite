//
//  Endpoint.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import Foundation

protocol Endpoint {
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var headers: [String: String] { get }
    var body: [String: String] { get }
    var urlParams: [String: String] { get }
}

extension Endpoint {
    func createURLRequest() throws {
        throw NetworkError.invalidURL
    }
}
