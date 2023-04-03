//
//  RestaurantDetailsViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

final class RestaurantDetailsViewSnapshotTests: XCTestCase {
    
    func test_restaurantDetailsViewIdleState() {
        let sut = makeSUT(getPlaceDetailsState: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_restaurantDetailsViewIsLoadingState() {
        let sut = makeSUT(getPlaceDetailsState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_restaurantDetailsViewFailureState() {
        let sut = makeSUT(getPlaceDetailsState: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_restaurantDetailsViewSuccessState() {
        let sut = makeSUT(getPlaceDetailsState: .success(makePlaceDetails()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_restaurantDetailsViewWhenGetPlaceDetailsStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .failure)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_restaurantDetailsViewWhenGetPlaceDetailsStateIsSuccessAndFetchPhotoStateIsSuccess() {
        let sut = makeSUT(getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .success(makePhotoData()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(getPlaceDetailsState: RestaurantDetailsViewModel.State, fetchPhotoState: PhotoViewModel.State = .isLoading) -> RestaurantDetailsView {
        let restaurantDetailsViewModel = RestaurantDetailsViewModel(
            input: .placeIdToFetch("place id"),
            getDistanceInKmFromCurrentLocation: { _ in 123.4 },
            restaurantDetailsService: EmptyRestaurantDetailsService(),
            getReviewsService: EmptyGetReviewsService()
        )
        restaurantDetailsViewModel.getPlaceDetailsState = getPlaceDetailsState
        
        let photoViewModel = PhotoViewModel(
            photoReference: "reference",
            restaurantPhotoService: EmptyPlacePhotoService()
        )
        photoViewModel.fetchPhotoState = fetchPhotoState
        
        return RestaurantDetailsView(
            viewModel: restaurantDetailsViewModel,
            makePhotoView: { _ in
                PhotoView(viewModel: photoViewModel)
            },
            showReviewView: {}
        )
    }
    
    private class EmptyGetReviewsService: GetReviewsService {
        func getReviews(placeID: String?) async throws -> [Review] { [] }
    }
}
 
