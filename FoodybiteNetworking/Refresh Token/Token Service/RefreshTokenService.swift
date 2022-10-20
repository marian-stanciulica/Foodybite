//
//  RefreshTokenService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

class RefreshTokenService: TokenRefresher {
    private let loader: ResourceLoader
    private let tokenStore: TokenStore
    
    init(loader: ResourceLoader, tokenStore: TokenStore) {
        self.loader = loader
        self.tokenStore = tokenStore
    }
    
    func getLocalToken() throws -> AuthToken {
        return try tokenStore.read()
    }
    
    func getRemoteToken() async throws -> AuthToken {
        let authToken = try tokenStore.read()
        let endpoint = ServerEndpoint.refreshToken(authToken.refreshToken)
        let urlRequest = try endpoint.createURLRequest()
        let remoteAuthToken: AuthToken = try await loader.get(for: urlRequest)
        try tokenStore.write(remoteAuthToken)
        return remoteAuthToken
    }
}
