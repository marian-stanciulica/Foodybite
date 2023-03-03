//
//  RefreshTokenService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

public class RefreshTokenService: TokenRefresher {
    private let loader: ResourceLoader
    private let tokenStore: TokenStore
    
    public init(loader: ResourceLoader, tokenStore: TokenStore) {
        self.loader = loader
        self.tokenStore = tokenStore
    }
    
    public func getLocalToken() throws -> AuthToken {
        return try tokenStore.read()
    }
    
    public func fetchLocallyRemoteToken() async throws {
        let authToken = try tokenStore.read()
        let endpoint = RefreshTokenEndpoint.post(RefreshTokenRequest(refreshToken: authToken.refreshToken))
        let urlRequest = try endpoint.createURLRequest()
        let remoteAuthToken: AuthToken = try await loader.get(for: urlRequest)
        try tokenStore.write(remoteAuthToken)
    }
}
