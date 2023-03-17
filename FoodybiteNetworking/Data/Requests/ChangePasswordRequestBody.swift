//
//  ChangePasswordRequestBody.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 24.11.2022.
//

struct ChangePasswordRequestBody: Encodable, Equatable {
    let currentPassword: String
    let newPassword: String
    let confirmPassword: String
}
