//
//  URLSessionProtocol.swift
//  SharedAPI
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation

public protocol URLSessionProtocol {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
