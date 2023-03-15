//
//  APIServiceTests+ReviewService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {
    
    func test_conformsToReviewService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as AddReviewService)
    }
    
    func test_addReview_usesAddReviewEndpointToCreateURLRequest() async throws {
        let placeID = anyPlaceID()
        let reviewText = anyReviewText()
        let starsNumber = anyStarsNumber()
        let createdAt = Date()
        let (sut, _, sender, _) = makeSUT()
        
        try await sut.addReview(
            placeID: placeID,
            reviewText: reviewText,
            starsNumber: starsNumber,
            createdAt: createdAt
        )
        
        XCTAssertEqual(sender.requests.count, 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/review",
            method: .post,
            body: AddReviewRequest(
                placeID: placeID,
                text: reviewText,
                stars: starsNumber,
                createdAt: createdAt
            )
        )
    }
    
    func test_getReviews_usesGetReviewsEndpointToCreateURLRequest() async throws {
        let (sut, loader, _, _) = makeSUT(response: anyGetReviews().response)
        let placeID = anyPlaceID()
        
        _ = try await sut.getReviews(placeID: placeID)
        
        XCTAssertEqual(loader.requests.count, 1)
        assertURLComponents(
            urlRequest: loader.requests[0],
            path: "/review/\(placeID)",
            method: .get,
            body: nil)
    }
    
    func test_getReviews_returnsExpectedReviews() async throws {
        let (response, expectedModel) = anyGetReviews()
        let (sut, _, _, _) = makeSUT(response: response)
        
        let receivedResponse = try await sut.getReviews()
        
        XCTAssertEqual(expectedModel, receivedResponse)
    }

    // MARK: - Helpers
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyReviewText() -> String {
        "any review text"
    }
    
    private func anyStarsNumber() -> Int {
        3
    }
    
    private func anyGetReviews() -> (response: [RemoteReview], model: [Review]) {
        let response = [
            RemoteReview(placeID: "place #1", profileImageData: anyData(), authorName: "author #1", reviewText: "review Text #1", rating: 3, createdAt: Date()),
            RemoteReview(placeID: "place #2", profileImageData: anyData(), authorName: "author #2", reviewText: "review Text #2", rating: 1, createdAt: Date()),
            RemoteReview(placeID: "place #3", profileImageData: anyData(), authorName: "author #3", reviewText: "review Text #3", rating: 4, createdAt: Date()),
        ]
        
        let formatter = RelativeDateTimeFormatter()
        let model = response.map {
            Review(id: $0.id,
                   placeID: $0.placeID,
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
