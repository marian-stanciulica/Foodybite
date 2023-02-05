//
//  GetReviewsService.swift
//  FoodybiteNetworking
//
//  Created by Marian Stanciulica on 05.02.2023.
//

import DomainModels

public protocol GetReviewsService {
    func getReviews(placeID: String?) async throws -> [Review]
}
