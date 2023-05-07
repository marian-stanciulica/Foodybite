//
//  SignUpRequestBody.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 17.11.2022.
//

import Foundation

struct SignUpRequestBody: Encodable, Equatable {
    let name: String
    let email: String
    let password: String
    let profileImage: Data?

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case profileImage = "profile_image"
    }
}
