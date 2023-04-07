//
//  ReviewDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 24.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class ReviewDAOTests: XCTestCase {

    func test_getReviews_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())

        do {
            let reviews = try await sut.getReviews()
            XCTFail("Expected to fail, received \(reviews) instead")
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

    func test_getReviews_returnsReviewsFromStoreForGivenRestaurantID() async  throws {
        let (sut, storeSpy) = makeSUT()
        let allReviews = makeReviews()
        let expectedReviews = [allReviews[1]]
        storeSpy.readAllResult = .success(allReviews)

        let receivedReviews = try await sut.getReviews(restaurantID: expectedReviews.first?.restaurantID)

        XCTAssertEqual(receivedReviews, expectedReviews)
    }

    func test_save_sendsReviewsToStore() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedReviews = makeReviews()

        try await sut.save(reviews: expectedReviews)

        XCTAssertEqual(storeSpy.messages.count, 1)

        if case let .writeAll(receivedReviews) = storeSpy.messages[0],
           let receivedReviews = receivedReviews as? [Review] {
            XCTAssertEqual(expectedReviews, receivedReviews)
        } else {
            XCTFail("Expected .write message, got \(storeSpy.messages[0]) instead")
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: ReviewDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = ReviewDAO(store: storeSpy)
        return (sut, storeSpy)
    }

    private func makeReviews() -> [Review] {
        [
            Review(
                restaurantID: "restaurant #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "review text #1",
                rating: 2,
                relativeTime: "1 hour ago"
            ),
            Review(
                restaurantID: "restaurant #2",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "review text #2",
                rating: 3,
                relativeTime: "one year ago"
            ),
            Review(
                restaurantID: "restaurant #3",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author name #1",
                reviewText: "review text #3",
                rating: 4,
                relativeTime: "2 months ago"
            )
        ]
    }

}
