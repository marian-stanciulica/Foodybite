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
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.port = 8080
        components.path = path

        guard let url = components.url else { throw  NetworkError.invalidURL }
        
        return URLRequest(url: url)
    }
}
