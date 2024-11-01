//
//  URLSessionHTTPClient.swift
//  API_Infra
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Foundation
import FoodybiteNetworking
import FoodybitePlaces

public final class URLSessionHTTPClient: FoodybitePlaces.HTTPClient, FoodybiteNetworking.HTTPClient {
    private let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    struct UnexpectedRepresentation: Error {}

    public func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let (data, response) = try await session.data(for: urlRequest, delegate: nil)

        guard let response = response as? HTTPURLResponse else {
            throw UnexpectedRepresentation()
        }

        return (data, response)
    }
}
