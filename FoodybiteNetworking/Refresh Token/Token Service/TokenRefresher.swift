//
//  TokenRefresher.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

protocol TokenRefresher {
    func getRemoteToken() async throws -> AuthToken
    func getLocalToken() throws -> AuthToken
}
