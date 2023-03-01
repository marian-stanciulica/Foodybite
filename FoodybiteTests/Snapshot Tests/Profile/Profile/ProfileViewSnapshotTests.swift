//
//  ProfileViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class ProfileViewSnapshotTests: XCTestCase {
    
    func test_profileViewWhenGetReviewsStateIsIdleForUserWithoutProfileImage() {
        let sut = makeSUT(user: makeUserWithoutProfileImage(),
                          getReviewsState: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsIdleForUserWithProfileImage() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsIsLoading() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsFailure() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsSuccessAndGetPlaceDetailsStateIsIsLoading() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getPlaceDetailsState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsSuccessAndGetPlaceDetailsStateIsFailure() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getPlaceDetailsState: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsSuccessAndGetPlaceDetailsStateIsSuccess() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsSuccessAndGetPlaceDetailsStateIsSuccessAndFetchPhotoStateIsFailure() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .failure(.serverError))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewWhenGetReviewsStateIsSuccessAndGetPlaceDetailsStateIsSuccessAndFetchPhotoStateIsSuccess() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          getReviewsState: .success(makeReviews()),
                          getPlaceDetailsState: .success(makePlaceDetails()),
                          fetchPhotoState: .success(makePhotoData()))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private typealias GetPlaceDetailsState = RestaurantReviewCellViewModel.State<PlaceDetails, RestaurantReviewCellViewModel.GetPlaceDetailsError>
    private typealias FetchPhotoState = RestaurantReviewCellViewModel.State<Data, RestaurantReviewCellViewModel.FetchPhotoError>
    
    private func makeSUT(
        user: User,
        getReviewsState: ProfileViewModel.State,
        getPlaceDetailsState: GetPlaceDetailsState = .idle,
        fetchPhotoState: FetchPhotoState = .idle
    ) -> UIViewController {
        let viewModel = ProfileViewModel(accountService: EmptyAccountService(), getReviewsService: EmptyGetReviewsService(), user: user, goToLogin: {})
        viewModel.getReviewsState = getReviewsState
        let profileView = ProfileView(
            viewModel: viewModel,
            cell: { self.makeCell(review: $0, getPlaceDetailsState: getPlaceDetailsState, fetchPhotoState: fetchPhotoState) },
            goToSettings: {},
            goToEditProfile: {}
        )
        let sut = UIHostingController(rootView: profileView)
        return sut
    }
    
    private func makeCell(review: Review, getPlaceDetailsState: GetPlaceDetailsState, fetchPhotoState: FetchPhotoState) -> RestaurantReviewCellView {
        let viewModel = RestaurantReviewCellViewModel(
            review: review,
            getPlaceDetailsService: EmptyGetPlaceDetailsService(),
            fetchPlacePhotoService: EmptyFetchPlacePhotoService()
        )
        viewModel.getPlaceDetailsState = getPlaceDetailsState
        viewModel.fetchPhotoState = fetchPhotoState
        let cell = RestaurantReviewCellView(
            viewModel: viewModel,
            showPlaceDetails: { _ in }
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
            Review(placeID: "",
                   profileImageURL: nil,
                   profileImageData: UIImage.make(withColor: .red).pngData(),
                   authorName: "Testing",
                   reviewText: "That was nice",
                   rating: 4,
                   relativeTime: "an hour ago"),
            Review(placeID: "",
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
        func getReviews(placeID: String?) async throws -> [Review] {
            []
        }
    }
}
