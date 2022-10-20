//
//  AuthToken.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 20.10.2022.
//

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
}
