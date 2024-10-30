//
//  ReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import Testing
import Foundation.NSError
import Domain
import FoodybitePresentation

struct ReviewViewModelTests {

    @Test func init_stateIsIdle() {
        let (sut, _) = makeSUT()

        #expect(sut.state == .idle)
        #expect(sut.reviewText == "")
        #expect(sut.starsNumber == 0)
    }

    @Test func isLoading_isTrueOnlyWhenStateIsLoading() {
        let (sut, _) = makeSUT()

        sut.state = .idle
        #expect(sut.isLoading == false)

        sut.state = .isLoading
        #expect(sut.isLoading == true)

        sut.state = .failure(.serverError)
        #expect(sut.isLoading == false)

        sut.state = .success
        #expect(sut.isLoading == false)
    }

    @Test func postReview_sendsParametersCorrectlyToReviewService() async {
        let expectedRestaurantID = anyRestaurantID()
        let (sut, reviewServiceSpy) = makeSUT(restaurantID: expectedRestaurantID)
        sut.reviewText = anyReviewText()
        sut.starsNumber = anyStarsNumber()

        await sut.addReview()

        #expect(reviewServiceSpy.capturedValues.count == 1)
        #expect(reviewServiceSpy.capturedValues.first?.restaurantID == expectedRestaurantID)
        #expect(reviewServiceSpy.capturedValues.first?.reviewText == anyReviewText())
        #expect(reviewServiceSpy.capturedValues.first?.starsNumber == anyStarsNumber())
    }

    @Test func postReview_setsStateToLoadingErrorWhenReviewServiceThrowsError() async {
        let (sut, reviewServiceSpy) = makeSUT()
        reviewServiceSpy.error = anyError()
        let stateSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        await sut.addReview()

        #expect(stateSpy.results == [.idle, .isLoading, .failure(.serverError)])
    }

    @Test func postReview_setsStateToRequestSucceededWhenReviewServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        let stateSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        await sut.addReview()

        #expect(stateSpy.results == [.idle, .isLoading, .success])
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
