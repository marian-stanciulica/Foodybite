//
//  GetReviewsServiceWithFallbackComposite.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 14.03.2023.
//

import Domain

public final class GetReviewsServiceWithFallbackComposite: GetReviewsService {
    private let primary: GetReviewsService
    private let secondary: GetReviewsService
    
    public init(primary: GetReviewsService, secondary: GetReviewsService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public func getReviews(restaurantID: String? = nil) async throws -> [Review] {
        do {
            return try await primary.getReviews(restaurantID: restaurantID)
        } catch {
            return try await secondary.getReviews(restaurantID: restaurantID)
        }
    }
}
