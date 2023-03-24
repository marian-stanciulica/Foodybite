//
//  ReviewDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 24.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class ReviewDAO: GetReviewsService {
    private let store: LocalStore

    init(store: LocalStore) {
        self.store = store
    }
    
    func getReviews(placeID: String? = nil) async throws -> [Review] {
        []
    }
}

final class ReviewDAOTests: XCTestCase {

    func test_getReviews_deliversEmptyArrayOnCacheMiss() async throws {
        let (sut, _) = makeSUT()
        
        let receivedReviews = try await sut.getReviews()
        
        XCTAssertTrue(receivedReviews.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ReviewDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = ReviewDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
}
