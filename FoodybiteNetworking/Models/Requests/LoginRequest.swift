//
//  LoginRequest.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 17.11.2022.
//

struct LoginRequest: Codable, Equatable {
    var email: String
    var password: String
}
