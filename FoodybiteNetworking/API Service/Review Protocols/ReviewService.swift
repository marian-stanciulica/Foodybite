//
//  ReviewService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import DomainModels

public protocol ReviewService {
    func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws
    func getReviews(placeID: String?) async throws -> [Review]
}
