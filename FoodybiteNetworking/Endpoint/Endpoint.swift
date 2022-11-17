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
    var body: Codable? { get }
}

extension Endpoint {
    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "http"
        components.host = host
        components.port = 8080
        components.path = path

        guard let url = components.url else { throw  NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if let encodable = body {
            let encoder = JSONEncoder()
            urlRequest.httpBody = try? encoder.encode(encodable)
        }
        
        return urlRequest
    }
}
