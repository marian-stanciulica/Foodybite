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
    private var refreshTask: Task<AuthToken, Error>?
    
    public init(loader: ResourceLoader, tokenStore: TokenStore) {
        self.loader = loader
        self.tokenStore = tokenStore
    }
    
    nonisolated public func getLocalToken() throws -> AuthToken {
        return try tokenStore.read()
    }
    
    public func fetchLocallyRemoteToken() async throws {
        if let refreshTask = refreshTask {
            _ = try await refreshTask.value
            return
        }
        
        let urlRequest = try createURLRequest()
        
        let task: Task<AuthToken, Error> = Task {
            defer { refreshTask = nil }
            return try await loader.get(for: urlRequest)
        }
        refreshTask = task
        
        let remoteAuthToken: AuthToken = try await task.value
        try tokenStore.write(remoteAuthToken)
    }
    
    private func createURLRequest() throws -> URLRequest {
        let authToken = try tokenStore.read()
        let body = RefreshTokenRequestBody(refreshToken: authToken.refreshToken)
        let endpoint = RefreshTokenEndpoint(requestBody: body)
        return try endpoint.createURLRequest()
    }
}
