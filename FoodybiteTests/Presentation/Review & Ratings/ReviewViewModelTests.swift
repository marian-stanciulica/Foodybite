//
//  ReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import XCTest
import Foodybite
import FoodybiteNetworking

final class ReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    func test_postReview_sendsParametersCorrectlyToReviewService() async {
        let expectedPlaceId = anyPlaceID()
        let (sut, reviewServiceSpy) = makeSUT(placeID: expectedPlaceId)
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()
        
        await sut.addReview()
        
        XCTAssertEqual(reviewServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(reviewServiceSpy.capturedValues[0].placeID, expectedPlaceId)
        XCTAssertEqual(reviewServiceSpy.capturedValues[0].reviewText, anyReviewText())
        XCTAssertEqual(reviewServiceSpy.capturedValues[0].startNumber, anyStarsNumber())
    }
    
    func test_postReview_setsStateToLoadingErrorWhenReviewServiceThrowsError() async {
        let (sut, reviewServiceSpy) = makeSUT()
        reviewServiceSpy.error = anyError()
        let stateSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())
        
        await sut.addReview()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .loadingError("Review couldn't be posted. Try again!")])
    }
    
    func test_postReview_setsStateToRequestSucceededWhenReviewServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        let stateSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        await sut.addReview()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .requestSucceeeded])
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
    
    private func anyReviewText() -> String {
        "any review text"
    }
    
    private func anyStarsNumber() -> Int {
        3
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private class ReviewServiceSpy: AddReviewService {
        private(set) var capturedValues = [(placeID: String, reviewText: String, startNumber: Int)]()
        var error: Error?
        
        func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws {
            capturedValues.append((placeID, reviewText, starsNumber))
            
            if let error = error {
                throw error
            }
        }
    }
    
}
