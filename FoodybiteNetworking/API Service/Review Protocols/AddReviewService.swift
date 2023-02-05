//
//  ReviewService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

public protocol AddReviewService {
    func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws
}
