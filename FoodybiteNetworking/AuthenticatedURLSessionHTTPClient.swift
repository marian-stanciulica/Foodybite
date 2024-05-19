//
//  AuthenticatedURLSessionHTTPClient.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import Foundation

public final class AuthenticatedURLSessionHTTPClient: HTTPClient {
    private let decoratee: HTTPClient
    private let tokenRefresher: TokenRefresher

    public init(decoratee: HTTPClient, tokenRefresher: TokenRefresher) {
        self.decoratee = decoratee
        self.tokenRefresher = tokenRefresher
    }

    public func send(_ urlRequest: URLRequest) async throws -> (data: Data, response: HTTPURLResponse) {
        let signedURLRequest = try sign(request: urlRequest)
        let (data, response) = try await decoratee.send(signedURLRequest)

        if response.statusCode == 401 {
            try await tokenRefresher.fetchLocallyRemoteToken()
            let signedURLRequest = try sign(request: urlRequest)
            return try await decoratee.send(signedURLRequest)
        }

        return (data, response)
    }

    private func sign(request: URLRequest) throws -> URLRequest {
        let localAuthToken = try tokenRefresher.getLocalToken()

        var signedURLRequest = request
        signedURLRequest.setValue("Bearer \(localAuthToken.accessToken)", forHTTPHeaderField: "Authorization")
        return signedURLRequest
    }
}
