//
//  HTTPClient.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 29.03.2023.
//

import Foundation

public protocol HTTPClient: Sendable {
    func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
