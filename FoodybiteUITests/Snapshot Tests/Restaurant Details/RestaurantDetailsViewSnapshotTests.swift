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
        let sut = makeSUT(getRestaurantDetailsState: .idle)

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    func test_restaurantDetailsViewIsLoadingState() {
        let sut = makeSUT(getRestaurantDetailsState: .isLoading)

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    func test_restaurantDetailsViewFailureState() {
        let sut = makeSUT(getRestaurantDetailsState: .failure(.serverError))

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    func test_restaurantDetailsViewSuccessState() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()))

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    func test_restaurantDetailsViewWhenGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .failure)

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    func test_restaurantDetailsViewWhenGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsSuccess() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .success(makePhotoData()))

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    // MARK: - Helpers

    private func makeSUT(
        getRestaurantDetailsState: RestaurantDetailsViewModel.State,
        fetchPhotoState: PhotoViewModel.State = .isLoading
    ) -> RestaurantDetailsView {
        let restaurantDetailsViewModel = RestaurantDetailsViewModel(
            input: .restaurantIdToFetch("restaurant id"),
            getDistanceInKmFromCurrentLocation: { _ in 123.4 },
            restaurantDetailsService: EmptyRestaurantDetailsService(),
            getReviewsService: EmptyGetReviewsService()
        )
        restaurantDetailsViewModel.getRestaurantDetailsState = getRestaurantDetailsState

        let photoViewModel = PhotoViewModel(
            photoReference: "reference",
            restaurantPhotoService: EmptyRestaurantPhotoService()
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
        func getReviews(restaurantID: String?) async throws -> [Review] { [] }
    }
}
