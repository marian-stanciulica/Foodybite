//
//  AddReviewRequest.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Foundation

public struct AddReviewRequest: Codable, Equatable {
    let placeID: String
    let text: String
    let stars: Int
    let createdAt: Date
    
    public init(placeID: String, text: String, stars: Int, createdAt: Date) {
        self.placeID = placeID
        self.text = text
        self.stars = stars
        self.createdAt = createdAt
    }
}
