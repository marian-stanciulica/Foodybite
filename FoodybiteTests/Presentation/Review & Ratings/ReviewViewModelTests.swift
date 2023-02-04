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
        case isLoading
    }
    
    private let reviewService: ReviewService
    private let placeID: String
    var state: State = .idle
    var reviewText = ""
    var starsNumber = 0
    
    init(placeID: String, reviewService: ReviewService) {
        self.placeID = placeID
        self.reviewService = reviewService
    }
    
    func addReview() async {
        state = .isLoading
        try? await reviewService.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber)
    }
}

final class ReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    func test_postReview_sendsPlaceIdToReviewService() async {
        let expectedPlaceId = anyPlaceID()
        let (sut, reviewServiceSpy) = makeSUT(placeID: expectedPlaceId)
        
        await sut.addReview()
        
        XCTAssertEqual(reviewServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(reviewServiceSpy.capturedValues[0], expectedPlaceId)
    }
    
    func test_postReview_setsStateToLoading() async {
        let (sut, _) = makeSUT()
        
        await sut.addReview()
        
        XCTAssertEqual(sut.state, .isLoading)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(placeID: String = "") -> (sut: ReviewViewModel, reviewServiceSpy: ReviewServiceSpy) {
        let reviewServiceSpy = ReviewServiceSpy()
        let sut = ReviewViewModel(placeID: placeID, reviewService: reviewServiceSpy)
        return (sut, reviewServiceSpy)
    }
    
    private func anyPlaceID() -> String {
        "any place id"
    }
    
    private class ReviewServiceSpy: ReviewService {
        private(set) var capturedValues = [String]()
        
        func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws {
            capturedValues.append(placeID)
        }
    }
    
}
