//
//  RefreshTokenService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import Foundation

public actor RefreshTokenService: TokenRefresher {
    private let loader: ResourceLoader
    private let tokenStore: TokenStore
    private var refreshTask: Task<Void, Error>?

    public init(loader: ResourceLoader, tokenStore: TokenStore) {
        self.loader = loader
        self.tokenStore = tokenStore
    }

    nonisolated public func getLocalToken() throws -> AuthToken {
        return try tokenStore.read()
    }

    public func fetchLocallyRemoteToken() async throws {
        if let refreshTask = refreshTask {
            return try await refreshTask.value
        }

        let urlRequest = try createURLRequest()

        let task: Task<Void, Error> = Task {
            let remoteAuthToken: AuthToken = try await loader.get(for: urlRequest)
            try tokenStore.write(remoteAuthToken)

            refreshTask = nil
        }

        refreshTask = task
        try await task.value
    }

    private func createURLRequest() throws -> URLRequest {
        let authToken = try tokenStore.read()
        let body = RefreshTokenRequestBody(refreshToken: authToken.refreshToken)
        let endpoint = RefreshTokenEndpoint(requestBody: body)
        return try endpoint.createURLRequest()
    }
}
