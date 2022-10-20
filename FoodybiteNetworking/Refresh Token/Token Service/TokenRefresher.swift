//
//  TokenRefresher.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

protocol TokenRefresher {
    func fetchLocallyRemoteToken() async throws
    func getLocalToken() throws -> AuthToken
}
