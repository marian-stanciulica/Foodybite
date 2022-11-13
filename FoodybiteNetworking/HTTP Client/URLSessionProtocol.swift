//
//  URLSessionProtocol.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
