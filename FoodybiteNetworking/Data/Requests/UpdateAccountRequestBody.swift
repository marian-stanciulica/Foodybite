//
//  UpdateAccountRequestBody.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation

struct UpdateAccountRequestBody: Encodable, Equatable {
    let name: String
    let email: String
    let profileImage: Data?
}
