//
//  Endpoint.swift
//  SharedAPI
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation

public protocol Endpoint {
    var scheme: String { get }
    var port: Int? { get }
    var host: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var method: RequestMethod { get }
    var body: Codable? { get }
}

extension Endpoint {
    public func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.port = port
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else { throw  NetworkError.invalidURL }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = ["Content-Type" : "application/json"]
        
        
        if let encodable = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            urlRequest.httpBody = try? encoder.encode(encodable)
        }
        
        return urlRequest
    }
}
