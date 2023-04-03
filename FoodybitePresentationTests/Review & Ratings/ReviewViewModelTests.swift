//
//  ReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import XCTest
import Domain
import FoodybitePresentation

final class ReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    func test_isLoading_isTrueOnlyWhenStateIsLoading() {
        let (sut, _) = makeSUT()

        sut.state = .idle
        XCTAssertFalse(sut.isLoading)
        
        sut.state = .isLoading
        XCTAssertTrue(sut.isLoading)
        
        sut.state = .failure(.serverError)
        XCTAssertFalse(sut.isLoading)
        
        sut.state = .success
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_postReview_sendsParametersCorrectlyToReviewService() async {
        let expectedRestaurantID = anyRestaurantID()
        let (sut, reviewServiceSpy) = makeSUT(restaurantID: expectedRestaurantID)
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()
        
        await sut.addReview()
        
        XCTAssertEqual(reviewServiceSpy.capturedValues.count, 1)
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.restaurantID, expectedRestaurantID)
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.reviewText, anyReviewText())
        XCTAssertEqual(reviewServiceSpy.capturedValues.first?.starsNumber, anyStarsNumber())
    }
    
    func test_postReview_setsStateToLoadingErrorWhenReviewServiceThrowsError() async {
        let (sut, reviewServiceSpy) = makeSUT()
        reviewServiceSpy.error = anyError()
        let stateSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())
        
        await sut.addReview()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .failure(.serverError)])
    }
    
    func test_postReview_setsStateToRequestSucceededWhenReviewServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        let stateSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        await sut.addReview()
        
        XCTAssertEqual(stateSpy.results, [.idle, .isLoading, .success])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(restaurantID: String = "") -> (sut: ReviewViewModel, reviewServiceSpy: ReviewServiceSpy) {
        let reviewServiceSpy = ReviewServiceSpy()
        let sut = ReviewViewModel(restaurantID: restaurantID, reviewService: reviewServiceSpy)
        return (sut, reviewServiceSpy)
    }
    
    private func anyRestaurantID() -> String {
        "any restaurant id"
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
        private(set) var capturedValues = [(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date)]()
        var error: Error?
        
        func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {
            capturedValues.append((restaurantID, reviewText, starsNumber, createdAt))
            
            if let error = error {
                throw error
            }
        }
    }
    
}
