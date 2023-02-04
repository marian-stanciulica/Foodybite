//
//  ReviewEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import XCTest
import FoodybiteNetworking

final class ReviewEndpointTests: XCTestCase {
    
    func test_addReview_baseURL() {
        XCTAssertEqual(makeAddReviewSUT().host, "localhost")
    }
    
    func test_addReview_path() {
        XCTAssertEqual(makeAddReviewSUT().path, "/review")
    }
    
    func test_addReview_methodIsPost() {
        XCTAssertEqual(makeAddReviewSUT().method, .post)
    }
    
    func test_addReview_body() throws {
        let body = AddReviewRequest(placeID: anyPlaceID(), text: anyReviewText(), stars: anyStarsNumber())
        let sut = makeAddReviewSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? AddReviewRequest)
        
        XCTAssertEqual(receivedBody, body)
    }
    
    func test_addReview_headersContainContentTypeJSON() {
        XCTAssertEqual(makeAddReviewSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Helpers
    
    private func makeAddReviewSUT(body: AddReviewRequest? = nil) -> ReviewEndpoint {
        let defaultBody = AddReviewRequest(placeID: anyPlaceID(), text: anyReviewText(), stars: anyStarsNumber())
        return .addReview(body ?? defaultBody)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private func anyReviewText() -> String {
        "any review text"
    }
    
    private func anyStarsNumber() -> Int {
        3
    }
    
}
