//
//  HTTPClient.swift
//  SharedAPI
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation

public protocol HTTPClient {
    func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
