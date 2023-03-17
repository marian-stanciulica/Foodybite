//
//  LoginRequestBody.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 17.11.2022.
//

struct LoginRequestBody: Encodable, Equatable {
    let email: String
    let password: String
}
