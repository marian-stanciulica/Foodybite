//
//  ReviewService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Foundation

public protocol AddReviewService: Sendable {
    func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws
}
