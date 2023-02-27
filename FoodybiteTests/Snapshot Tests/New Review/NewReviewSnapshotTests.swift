//
//  NewReviewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class NewReviewSnapshotTests: XCTestCase {
    
    func test_newReviewViewIdleState() {
        let sut = makeSUT()
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    // MARK: - Helpers
    
    private func makeSUT() -> UIViewController {
        let viewModel = NewReviewViewModel(
            autocompletePlacesService: EmptyAutocompletePlacesService(),
            getPlaceDetailsService: EmptyGetPlaceDetailsService(),
            addReviewService: EmptyAddReviewService(),
            location: Location(latitude: 0, longitude: 0)
        )
        let newReviewView = NewReviewView(
            currentPage: .constant(.newReview),
            plusButtonActive: .constant(true),
            viewModel: viewModel,
            selectedView: { _ in EmptyView() }
        )
        let sut = UIHostingController(rootView: newReviewView)
        return sut
    }
    
    private class EmptyAutocompletePlacesService: AutocompletePlacesService {
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] { [] }
    }
    
    private class EmptyAddReviewService: AddReviewService {
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
