//
//  APIServiceTests+ReviewService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
import Foundation.NSDate
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    @Test func conformsToReviewService() {
        let (sut, _, _, _) = makeSUT()
        #expect(sut as AddReviewService != nil)
    }

    @Test func addReview_usesAddReviewEndpointToCreateURLRequest() async throws {
        let restaurantID = anyRestaurantID()
        let reviewText = anyReviewText()
        let starsNumber = anyStarsNumber()
        let createdAt = Date()
        let (sut, _, sender, _) = makeSUT()

        try await sut.addReview(
            restaurantID: restaurantID,
            reviewText: reviewText,
            starsNumber: starsNumber,
            createdAt: createdAt
        )

        #expect(sender.requests.count == 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/review",
            method: .post,
            body: AddReviewRequestBody(
                restaurantID: restaurantID,
                text: reviewText,
                stars: starsNumber,
                createdAt: createdAt
            )
        )
    }

    @Test func getReviews_usesGetReviewsEndpointToCreateURLRequest() async throws {
        let (sut, loader, _, _) = makeSUT(response: anyGetReviews().response)
        let restaurantID = anyRestaurantID()

        _ = try await sut.getReviews(restaurantID: restaurantID)

        #expect(loader.requests.count == 1)
        assertURLComponents(
            urlRequest: loader.requests[0],
            path: "/review/\(restaurantID)",
            method: .get,
            body: nil)
    }

    @Test func getReviews_returnsExpectedReviews() async throws {
        let (response, expectedModel) = anyGetReviews()
        let (sut, _, _, _) = makeSUT(response: response)

        let receivedResponse = try await sut.getReviews()

        #expect(expectedModel == receivedResponse)
    }

    // MARK: - Helpers

    private func anyRestaurantID() -> String {
        "any restaurant id"
    }

    private func anyReviewText() -> String {
        "any review text"
    }

    private func anyStarsNumber() -> Int {
        3
    }

    private func anyGetReviews() -> (response: [RemoteReview], model: [Review]) {
        let response = [
            RemoteReview(
                restaurantID: "restaurant #1",
                profileImageData: anyData(),
                authorName: "author #1",
                reviewText: "review Text #1",
                rating: 3,
                createdAt: Date()
            ),
            RemoteReview(
                restaurantID: "restaurant #2",
                profileImageData: anyData(),
                authorName: "author #2",
                reviewText: "review Text #2",
                rating: 1,
                createdAt: Date()
            ),
            RemoteReview(
                restaurantID: "restaurant #3",
                profileImageData: anyData(),
                authorName: "author #3",
                reviewText: "review Text #3",
                rating: 4,
                createdAt: Date()
            )
        ]

        let formatter = RelativeDateTimeFormatter()
        let model = response.map {
            Review(id: $0.id,
                   restaurantID: $0.restaurantID,
                   profileImageURL: nil,
                   profileImageData: $0.profileImageData,
                   authorName: $0.authorName,
                   reviewText: $0.reviewText,
                   rating: $0.rating,
                   relativeTime: formatter.localizedString(for: $0.createdAt, relativeTo: Date())
            )
        }

        return (response, model)
    }

}
