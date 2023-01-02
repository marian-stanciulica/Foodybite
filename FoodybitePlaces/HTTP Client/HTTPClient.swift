//
//  HTTPClient.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

public protocol HTTPClient {
    func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse)
}
