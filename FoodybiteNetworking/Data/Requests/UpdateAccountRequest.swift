//
//  UpdateAccountRequest.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation

struct UpdateAccountRequest: Codable, Equatable {
    let name: String
    let email: String
    let profileImage: Data?
}
