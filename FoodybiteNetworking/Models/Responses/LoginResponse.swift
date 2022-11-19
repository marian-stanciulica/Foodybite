//
//  LoginResponse.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 15.10.2022.
//

public struct LoginResponse: Decodable {
    public let user: RemoteUser
    public let token: AuthToken
    
    public init(user: RemoteUser, token: AuthToken) {
        self.user = user
        self.token = token
    }
}
