//
//  GetReviewsService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 05.02.2023.
//

public protocol GetReviewsService {
    func getReviews(restaurantID: String?) async throws -> [Review]
}
