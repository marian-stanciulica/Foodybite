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
    
    func test_newReviewViewWithAutocompletePredictions() {
        let sut = makeSUT(searchText: "Pred",
                          autocompletePredictions: makeAutocompletePredictions())
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13), record: true)
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13), record: true)
    }

    // MARK: - Helpers
    
    private func makeSUT(searchText: String = "", autocompletePredictions: [AutocompletePrediction] = []) -> UIViewController {
        let viewModel = NewReviewViewModel(
            autocompletePlacesService: EmptyAutocompletePlacesService(),
            getPlaceDetailsService: EmptyGetPlaceDetailsService(),
            addReviewService: EmptyAddReviewService(),
            location: Location(latitude: 0, longitude: 0)
        )
        viewModel.searchText = searchText
        viewModel.autocompleteResults = autocompletePredictions
        
        let newReviewView = NewReviewView(
            currentPage: .constant(.newReview),
            plusButtonActive: .constant(true),
            viewModel: viewModel,
            selectedView: { _ in EmptyView() }
        )
        let sut = UIHostingController(rootView: newReviewView)
        return sut
    }
    
    private func makeAutocompletePredictions() -> [AutocompletePrediction] {
        [
            AutocompletePrediction(placePrediction: "Prediction #1", placeID: "place #1"),
            AutocompletePrediction(placePrediction: "Prediction #2", placeID: "place #2"),
            AutocompletePrediction(placePrediction: "Prediction #3", placeID: "place #3")
        ]
    }
    
    private class EmptyAutocompletePlacesService: AutocompletePlacesService {
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] { [] }
    }
    
    private class EmptyAddReviewService: AddReviewService {
        func addReview(placeID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
