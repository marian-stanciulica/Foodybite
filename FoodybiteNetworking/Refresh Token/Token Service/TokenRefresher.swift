//
//  TokenRefresher.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

public protocol TokenRefresher {
    func fetchLocallyRemoteToken() async throws
    func getLocalToken() throws -> AuthToken
}
