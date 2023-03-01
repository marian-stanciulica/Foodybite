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
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewViewWhenGetPlaceDetailsStateIsSuccess() {
        let sut = makeSUT(getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenFetchPhotoStateIsFailure() {
        let sut = makeSUT(getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .failure)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenFetchPhotoStateIsSuccess() {
        let sut = makeSUT(getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .success(makePhotoData()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenInputIsValidPostButtonIsEnabled() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .failure)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenPostReviewStateIsIsLoading() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .failure,
                          postReviewState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        searchText: String = "",
        starsNumber: Int = 0,
        reviewText: String = "",
        autocompletePredictions: [AutocompletePrediction] = [],
        getPlaceDetailsState: NewReviewViewModel.GetPlaceDetailsState = .idle,
        fetchPhotoState: PhotoViewModel.State = .isLoading,
        postReviewState: NewReviewViewModel.PostReviewState = .idle
    ) -> UIViewController {
        let viewModel = NewReviewViewModel(
            autocompletePlacesService: EmptyAutocompletePlacesService(),
            getPlaceDetailsService: EmptyGetPlaceDetailsService(),
            addReviewService: EmptyAddReviewService(),
            location: Location(latitude: 0, longitude: 0)
        )
        viewModel.searchText = searchText
        viewModel.starsNumber = starsNumber
        viewModel.reviewText = reviewText
        viewModel.autocompleteResults = autocompletePredictions
        viewModel.getPlaceDetailsState = getPlaceDetailsState
        viewModel.postReviewState = postReviewState
        
        let newReviewView = NewReviewView(
            currentPage: .constant(.newReview),
            plusButtonActive: .constant(true),
            viewModel: viewModel,
            selectedView: { self.makeCell(placeDetails: $0, fetchPhotoState: fetchPhotoState) }
        )
        let sut = UIHostingController(rootView: newReviewView)
        return sut
    }
    
    private func makeCell(placeDetails: PlaceDetails, fetchPhotoState: PhotoViewModel.State) -> SelectedRestaurantView {
        let viewModel = PhotoViewModel(
            photoReference: placeDetails.photos.first?.photoReference,
            fetchPhotoService: EmptyFetchPlacePhotoService()
        )
        viewModel.fetchPhotoState = fetchPhotoState
        let view = SelectedRestaurantView(photoView: PhotoView(viewModel: viewModel), placeDetails: placeDetails)
        return view
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