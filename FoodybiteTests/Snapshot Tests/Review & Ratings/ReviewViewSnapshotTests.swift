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
@testable import Foodybite

final class ReviewViewSnapshotTests: XCTestCase {
    
    func test_reviewViewIdleState() {
        let sut = makeSUT(state: .idle)
        
        assertSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_reviewViewIsLoadingState() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          state: .isLoading)
        
        assertSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_reviewViewFailureState() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          state: .failure(.serverError))
        
        assertSnapshot(matching: sut, as: .image(on: .iPhone13))
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
    
    private func makeReviewText() -> String {
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sit amet dapibus justo, eu cursus nulla. Nulla viverra mollis ante et rutrum. Mauris lorem ante, congue eget malesuada quis, hendrerit vel elit. Suspendisse potenti. Phasellus molestie vehicula blandit. Fusce sit amet egestas augue. Integer quis lacinia massa. Aliquam hendrerit arcu eget leo congue maximus. Etiam interdum eget mi at consectetur."
    }
    
    private class EmptyAddReviewService: AddReviewService {
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
