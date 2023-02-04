//
//  ReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import XCTest
import FoodybiteNetworking

final class ReviewViewModel {
    enum State {
        case idle
    }
    
    private let reviewService: ReviewService
    var state: State = .idle
    
    init(reviewService: ReviewService) {
        self.reviewService = reviewService
    }
    
    func addReview(placeID: String, reviewText: String, starsNumber: Int) async {
        try? await reviewService.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber)
    }
}

final class ReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
    }
    
    func test_postReview_callsReviewService() async {
        let (sut, reviewServiceSpy) = makeSUT()
        
        await sut.addReview(placeID: anyPlaceID(), reviewText: anyReviewText(), starsNumber: anyStarsNumber())
        
        XCTAssertEqual(reviewServiceSpy.addReviewCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ReviewViewModel, reviewServiceSpy: ReviewServiceSpy) {
        let reviewServiceSpy = ReviewServiceSpy()
        let sut = ReviewViewModel(reviewService: reviewServiceSpy)
        return (sut, reviewServiceSpy)
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
    
    private class ReviewServiceSpy: ReviewService {
        private(set) var addReviewCallCount = 0
        
        func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws {
            addReviewCallCount += 1
        }
    }
    
}
