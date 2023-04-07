//
//  TokenRefresherFake.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 20.10.2022.
//

import FoodybiteNetworking

class TokenRefresherFake: TokenRefresher {
    private let remoteToken = AuthToken(accessToken: "remote access token", refreshToken: "remote refresh token")
    private var localToken = AuthToken(accessToken: "local access token", refreshToken: "local refresh token")
    var getRemoteTokenCalledCount = 0

    func fetchLocallyRemoteToken() async throws {
        getRemoteTokenCalledCount += 1
        localToken = remoteToken
    }

    func getLocalToken() throws -> AuthToken {
        return localToken
    }
}
