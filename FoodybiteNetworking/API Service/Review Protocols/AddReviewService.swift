//
//  ReviewService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import DomainModels

public protocol AddReviewService {
    func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws
//    func getReviews(placeID: String?) async throws -> [Review]
}
