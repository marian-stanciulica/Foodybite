//
//  LoginResponse.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

struct LoginResponse: Decodable {
    let remoteUser: RemoteUser
    let token: AuthToken

    enum CodingKeys: String, CodingKey {
        case remoteUser = "user"
        case token
    }
}
