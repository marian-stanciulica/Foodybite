//
//  RestaurantDetailsViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 01.03.2023.
//

import Testing
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

struct RestaurantDetailsViewSnapshotTests {

    @MainActor @Test func restaurantDetailsViewIdleState() {
        let sut = makeSUT(getRestaurantDetailsState: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func restaurantDetailsViewIsLoadingState() {
        let sut = makeSUT(getRestaurantDetailsState: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func restaurantDetailsViewFailureState() {
        let sut = makeSUT(getRestaurantDetailsState: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func restaurantDetailsViewSuccessState() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()))

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func restaurantDetailsViewWhenGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .failure)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func restaurantDetailsViewWhenGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsSuccess() {
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
