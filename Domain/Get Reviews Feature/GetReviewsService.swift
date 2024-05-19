//
//  GetReviewsService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 05.02.2023.
//

public protocol GetReviewsService: Sendable {
    func getReviews(restaurantID: String?) async throws -> [Review]
}
