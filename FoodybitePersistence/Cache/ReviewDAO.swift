//
//  ReviewDAO.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 24.03.2023.
//

import Domain

public final class ReviewDAO: GetReviewsService, ReviewCache {
    private let store: LocalStore

    public init(store: LocalStore) {
        self.store = store
    }
    
    public func getReviews(placeID: String? = nil) async throws -> [Review] {
        let reviews: [Review] = try await store.readAll()
        
        if let placeID = placeID {
            return reviews.filter { $0.placeID == placeID }
        }
        
        return reviews
    }
    
    public func save(reviews: [Review]) async throws {
        try await store.writeAll(reviews)
    }
}
