//
//  RestaurantDetailsViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

struct RestaurantDetailsViewSnapshotTests {

    func test_restaurantDetailsViewIdleState() {
        let sut = makeSUT(getRestaurantDetailsState: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_restaurantDetailsViewIsLoadingState() {
        let sut = makeSUT(getRestaurantDetailsState: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_restaurantDetailsViewFailureState() {
        let sut = makeSUT(getRestaurantDetailsState: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_restaurantDetailsViewSuccessState() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_restaurantDetailsViewWhenGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .failure)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_restaurantDetailsViewWhenGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsSuccess() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .success(makePhotoData()))

        assertLightAndDarkSnapshot(matching: sut)
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
