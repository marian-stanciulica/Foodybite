//
//  AddReviewRequestBody.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Foundation

struct AddReviewRequestBody: Codable, Equatable {
    let placeID: String
    let text: String
    let stars: Int
    let createdAt: Date
}
