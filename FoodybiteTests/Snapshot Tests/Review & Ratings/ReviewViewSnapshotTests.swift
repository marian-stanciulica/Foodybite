//
//  ReviewViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
import FoodybitePresentation
@testable import Foodybite

final class ReviewViewSnapshotTests: XCTestCase {
    
    func test_reviewViewIdleState() {
        let sut = makeSUT(state: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_reviewViewIsLoadingState() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          state: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_reviewViewFailureState() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          state: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(starsNumber: Int = 0, reviewText: String = "", state: ReviewViewModel.State) -> UIViewController {
        let viewModel = ReviewViewModel(placeID: "", reviewService: EmptyAddReviewService())
        viewModel.starsNumber = starsNumber
        viewModel.reviewText = reviewText
        viewModel.state = state
        let registerView = ReviewView(viewModel: viewModel, dismissScreen: {})
        let sut = UIHostingController(rootView: registerView)
        return sut
    }
    
    private class EmptyAddReviewService: AddReviewService {
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
