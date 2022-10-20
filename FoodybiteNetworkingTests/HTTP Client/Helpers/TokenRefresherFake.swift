//
//  TokenRefresherFake.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

@testable import FoodybiteNetworking

class TokenRefresherFake: TokenRefresher {
    var getRemoteTokenCalledCount = 0
    
    func getRemoteToken() async throws -> AuthToken {
        getRemoteTokenCalledCount += 1
        return AuthToken(accessToken: "remote access token", refreshToken: "remote refresh token")
    }
    
    func getLocalToken() throws -> AuthToken {
        return AuthToken(accessToken: "local access token", refreshToken: "local refresh token")
    }
}
