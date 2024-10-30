//
//  ReviewDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 24.03.2023.
//

import Testing
import Domain
import FoodybitePersistence

struct ReviewDAOTests {

    @Test func getReviews_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())

        do {
            let reviews = try await sut.getReviews()
            Issue.record("Expected to fail, received \(reviews) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func getReviews_returnsAllReviewsWhenStoreContainsReviews() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedReviews = makeReviews()
        storeSpy.readAllResult = .success(expectedReviews)

        let receivedReviews = try await sut.getReviews()

        #expect(receivedReviews == expectedReviews)
    }

    @Test func getReviews_returnsReviewsFromStoreForGivenRestaurantID() async  throws {
        let (sut, storeSpy) = makeSUT()
        let allReviews = makeReviews()
        let expectedReviews = [allReviews[1]]
        storeSpy.readAllResult = .success(allReviews)

        let receivedReviews = try await sut.getReviews(restaurantID: expectedReviews.first?.restaurantID)

        #expect(receivedReviews == expectedReviews)
    }

    @Test func save_sendsReviewsToStore() async throws {
        let (sut, storeSpy) = makeSUT()
        let expectedReviews = makeReviews()

        try await sut.save(reviews: expectedReviews)

        #expect(storeSpy.messages.count == 1)

        if case let .writeAll(receivedReviews) = storeSpy.messages[0],
           let receivedReviews = receivedReviews as? [Review] {
            #expect(expectedReviews == receivedReviews)
        } else {
            Issue.record("Expected .write message, got \(storeSpy.messages[0]) instead")
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
