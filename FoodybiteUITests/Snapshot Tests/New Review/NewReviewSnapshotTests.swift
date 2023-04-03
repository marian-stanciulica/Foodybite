//
//  NewReviewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

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
    
    func test_newReviewViewWhenGetRestaurantDetailsStateIsSuccess() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewViewWhenGetRestaurantDetailsStateIsIsLoading() {
        let sut = makeSUT(getRestaurantDetailsState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenFetchPhotoStateIsFailure() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .failure)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenFetchPhotoStateIsSuccess() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .success(makePhotoData()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenInputIsValidPostButtonIsEnabled() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .failure)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_newReviewWhenPostReviewStateIsIsLoading() {
        let sut = makeSUT(starsNumber: 4,
                          reviewText: makeReviewText(),
                          getRestaurantDetailsState: .success(makeRestaurantDetails()),
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
        getRestaurantDetailsState: NewReviewViewModel.RestaurantDetailsState = .idle,
        fetchPhotoState: PhotoViewModel.State = .isLoading,
        postReviewState: NewReviewViewModel.PostReviewState = .idle
    ) -> NewReviewView<SelectedRestaurantView> {
        let viewModel = NewReviewViewModel(
            autocompleteRestaurantsService: EmptyAutocompleteRestaurantsService(),
            restaurantDetailsService: EmptyRestaurantDetailsService(),
            addReviewService: EmptyAddReviewService(),
            location: Location(latitude: 0, longitude: 0),
            userPreferences: UserPreferences(radius: 0, starsNumber: 0)
        )
        viewModel.searchText = searchText
        viewModel.starsNumber = starsNumber
        viewModel.reviewText = reviewText
        viewModel.autocompleteResults = autocompletePredictions
        viewModel.getRestaurantDetailsState = getRestaurantDetailsState
        viewModel.postReviewState = postReviewState
        
        return NewReviewView(
            plusButtonActive: .constant(true),
            viewModel: viewModel,
            selectedView: { self.makeCell(restaurantDetails: $0, fetchPhotoState: fetchPhotoState) }
        )
    }
    
    private func makeCell(restaurantDetails: RestaurantDetails, fetchPhotoState: PhotoViewModel.State) -> SelectedRestaurantView {
        let viewModel = PhotoViewModel(
            photoReference: restaurantDetails.photos.first?.photoReference,
            restaurantPhotoService: EmptyRestaurantPhotoService()
        )
        viewModel.fetchPhotoState = fetchPhotoState
        let view = SelectedRestaurantView(photoView: PhotoView(viewModel: viewModel), restaurantDetails: restaurantDetails)
        return view
    }
    
    private func makeAutocompletePredictions() -> [AutocompletePrediction] {
        [
            AutocompletePrediction(restaurantPrediction: "Prediction #1", restaurantID: "restaurant #1"),
            AutocompletePrediction(restaurantPrediction: "Prediction #2", restaurantID: "restaurant #2"),
            AutocompletePrediction(restaurantPrediction: "Prediction #3", restaurantID: "restaurant #3")
        ]
    }
    
    private class EmptyAutocompleteRestaurantsService: AutocompleteRestaurantsService {
        func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] { [] }
    }
    
    private class EmptyAddReviewService: AddReviewService {
        func addReview(restaurantID: String, reviewText: String, starsNumber: Int, createdAt: Date) async throws {}
    }
}
