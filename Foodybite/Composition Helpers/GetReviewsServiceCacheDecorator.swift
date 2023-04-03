//
//  GetReviewsServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Domain

public final class GetReviewsServiceCacheDecorator: GetReviewsService {
    private let getReviewsService: GetReviewsService
    private let cache: ReviewCache
    
    public init(getReviewsService: GetReviewsService, cache: ReviewCache) {
        self.getReviewsService = getReviewsService
        self.cache = cache
    }
    
    public func getReviews(restaurantID: String? = nil) async throws -> [Review] {
        let reviews = try await getReviewsService.getReviews(restaurantID: restaurantID)
        try? await cache.save(reviews: reviews)
        return reviews
    }
}
