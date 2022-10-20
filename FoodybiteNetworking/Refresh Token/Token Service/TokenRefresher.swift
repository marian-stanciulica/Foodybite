//
//  TokenRefresher.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

protocol TokenRefresher {
    func getToken() async throws -> AuthToken
}
