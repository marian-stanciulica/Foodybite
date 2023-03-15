//
//  GetReviewsServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Domain

public final class GetReviewsServiceCacheDecorator: GetReviewsService {
    private let getReviewsService: GetReviewsService
    private let cache: ReviewsCache
    
    public init(getReviewsService: GetReviewsService, cache: ReviewsCache) {
        self.getReviewsService = getReviewsService
        self.cache = cache
    }
    
    public func getReviews(placeID: String? = nil) async throws -> [Review] {
        let reviews = try await getReviewsService.getReviews(placeID: placeID)
        try? await cache.save(reviews: reviews)
        return reviews
    }
}