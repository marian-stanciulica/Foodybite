//
//  ProfileViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

final class ProfileViewSnapshotTests: XCTestCase {

    func test_profileViewWhenGetReviewsStateIsIdleForUserWithoutProfileImage() {
        let sut = makeSUT(user: makeUserWithoutProfileImage(),
                          getReviewsState: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsIdleForUserWithProfileImage() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsIsLoading() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsFailure() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsSuccessAndGetRestaurantDetailsStateIsIsLoading() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getRestaurantDetailsState: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsSuccessAndGetRestaurantDetailsStateIsFailure() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getRestaurantDetailsState: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsSuccessAndGetRestaurantDetailsStateIsSuccess() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsSuccessAndGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .failure)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_profileViewWhenGetReviewsStateIsSuccessAndGetRestaurantDetailsStateIsSuccessAndFetchPhotoStateIsSuccess() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getRestaurantDetailsState: .success(makeRestaurantDetails()),
                          fetchPhotoState: .success(makePhotoData()))

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(
        user: User,
        getReviewsState: ProfileViewModel.State,
        getRestaurantDetailsState: RestaurantReviewCellViewModel.State = .idle,
        fetchPhotoState: PhotoViewModel.State = .isLoading
    ) -> ProfileView<RestaurantReviewCellView> {
        let viewModel = ProfileViewModel(
            accountService: EmptyAccountService(),
            getReviewsService: EmptyGetReviewsService(),
            user: user,
            goToLogin: {}
        )
        viewModel.getReviewsState = getReviewsState
        return ProfileView(
            viewModel: viewModel,
            cell: { self.makeCell(review: $0, getRestaurantDetailsState: getRestaurantDetailsState, fetchPhotoState: fetchPhotoState) },
            goToSettings: {},
            goToEditProfile: {}
        )
    }

    private func makeCell(
        review: Review,
        getRestaurantDetailsState: RestaurantReviewCellViewModel.State,
        fetchPhotoState: PhotoViewModel.State
    ) -> RestaurantReviewCellView {
        let restaurantReviewCellViewModel = RestaurantReviewCellViewModel(
            review: review,
            restaurantDetailsService: EmptyRestaurantDetailsService()
        )
        restaurantReviewCellViewModel.getRestaurantDetailsState = getRestaurantDetailsState

        let photoViewModel = PhotoViewModel(
            photoReference: "reference",
            restaurantPhotoService: EmptyRestaurantPhotoService()
        )
        photoViewModel.fetchPhotoState = fetchPhotoState

        let cell = RestaurantReviewCellView(
            viewModel: restaurantReviewCellViewModel,
            makePhotoView: { _ in
                PhotoView(viewModel: photoViewModel)
            },
            showRestaurantDetails: { _ in }
        )
        return cell
    }

    private func makeUserWithoutProfileImage() -> User {
        User(id: UUID(),
             name: "Testing",
             email: "testing@testing.com",
             profileImage: nil)
    }

    private func makeUserWithProfileImage() -> User {
        User(id: UUID(),
             name: "Testing",
             email: "testing@testing.com",
             profileImage: UIImage.make(withColor: .red).pngData())
    }

    private func makeReviews() -> [Review] {
        [
            Review(restaurantID: "",
                   profileImageURL: nil,
                   profileImageData: UIImage.make(withColor: .red).pngData(),
                   authorName: "Testing",
                   reviewText: "That was nice",
                   rating: 4,
                   relativeTime: "an hour ago"),
            Review(restaurantID: "",
                   profileImageURL: nil,
                   profileImageData: UIImage.make(withColor: .blue).pngData(),
                   authorName: "Testing",
                   reviewText: "That was nice",
                   rating: 4,
                   relativeTime: "an hour ago")
        ]
    }

    private class EmptyAccountService: AccountService {
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
        func deleteAccount() async throws {}
    }

    private class EmptyGetReviewsService: GetReviewsService {
        func getReviews(restaurantID: String?) async throws -> [Review] {
            []
        }
    }
}
