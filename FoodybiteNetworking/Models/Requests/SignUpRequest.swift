//
//  SignUpRequest.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 17.11.2022.
//

import Foundation

struct SignUpRequest: Codable, Equatable {
    let name: String
    let email: String
    let password: String
    let confirmPassword: String
    let profileImage: Data?
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case password
        case confirmPassword = "confirm_password"
        case profileImage = "profile_image"
    }
}
