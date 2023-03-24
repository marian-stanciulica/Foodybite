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
        let reviews: [Review] = try await store.readAll()
        
        if let placeID = placeID {
            return reviews.filter { $0.placeID == placeID }
        }
        
        return reviews
    }
}

final class ReviewDAOTests: XCTestCase {

    func test_getReviews_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let reviews = try await sut.getReviews()
            XCTFail("Expected to fail, received nearby places \(reviews) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getReviews_returnsAllReviewsWhenStoreContainsReviews() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedReviews = makeReviews()
        storeSpy.readAllResult = .success(expectedReviews)
        
        let receivedReviews = try await sut.getReviews()
        
        XCTAssertEqual(receivedReviews, expectedReviews)
    }
    
    func test_getReviews_returnsReviewsFromStoreForGivenPlaceID() async  throws {
        let (sut, storeSpy) = makeSUT()
        let allReviews = makeReviews()
        let expectedReviews = [allReviews[1]]
        storeSpy.readAllResult = .success(allReviews)
        
        let receivedReviews = try await sut.getReviews(placeID: expectedReviews.first?.placeID)
        
        XCTAssertEqual(receivedReviews, expectedReviews)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ReviewDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = ReviewDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
    private func makeReviews() -> [Review] {
        [
            Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #1", rating: 2, relativeTime: "1 hour ago"),
            Review(placeID: "place #2", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #2", rating: 3, relativeTime: "one year ago"),
            Review(placeID: "place #3", profileImageURL: nil, profileImageData: nil, authorName: "Author name #1", reviewText: "review text #3", rating: 4, relativeTime: "2 months ago")
        ]
    }
    
}
