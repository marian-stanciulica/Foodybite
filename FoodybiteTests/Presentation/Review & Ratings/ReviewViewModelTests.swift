//
//  ReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import XCTest
import FoodybiteNetworking

final class ReviewViewModel {
    enum State: Equatable {
        case idle
        case isLoading
        case loadingError(String)
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
        
        do {
            try await reviewService.addReview(placeID: placeID, reviewText: reviewText, starsNumber: starsNumber)
        } catch {
            state = .loadingError("Review couldn't be posted. Try again!")
        }
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
    
    func test_postReview_setsStateToLoadingErrorWhenReviewServiceThrowsError() async {
        let (sut, reviewServiceSpy) = makeSUT()
        reviewServiceSpy.error = anyError()
        
        await sut.addReview()
        
        XCTAssertEqual(sut.state, .loadingError("Review couldn't be posted. Try again!"))
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
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private class ReviewServiceSpy: ReviewService {
        private(set) var capturedValues = [String]()
        var error: Error?
        
        func addReview(placeID: String, reviewText: String, starsNumber: Int) async throws {
            capturedValues.append(placeID)
            
            if let error = error {
                throw error
            }
        }
    }
    
}
