//
//  LoginResponse.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

struct LoginResponse: Decodable {
    let user: RemoteUser
    let token: AuthToken
}
