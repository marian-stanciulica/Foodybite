//
//  ReviewViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.02.2023.
//

import Testing
import Foundation
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

struct ReviewViewSnapshotTests {

    @Test func reviewViewIdleState() {
        let sut = makeSUT(state: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @Test func reviewViewIsLoadingState() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          state: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @Test func reviewViewFailureState() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          state: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(starsNumber: Int = 0, reviewText: String = "", state: ReviewViewModel.State) -> ReviewView {
        let viewModel = ReviewViewModel(restaurantID: "", reviewService: EmptyAddReviewService())
        viewModel.starsNumber = starsNumber
        viewModel.reviewText = reviewText
        viewModel.state = state
        return ReviewView(viewModel: viewModel, dismissScreen: {})
    }

    private class EmptyAddReviewService: AddReviewService {
        func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
