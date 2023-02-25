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
    
    // MARK: - Helpers
    
    private func makeSUT(state: ReviewViewModel.State) -> UIViewController {
        let viewModel = ReviewViewModel(placeID: "", reviewService: EmptyAddReviewService())
        let registerView = ReviewView(viewModel: viewModel, dismissScreen: {})
        let sut = UIHostingController(rootView: registerView)
        return sut
    }
    
    private class EmptyAddReviewService: AddReviewService {
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
