//
//  ProfileFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Domain
import SwiftUI
import FoodybiteNetworking
import FoodybitePlaces

struct ProfileFlowView: View {
    @Binding var page: Page
    @ObservedObject var flow: Flow<ProfileRoute>
    let goToLogin: () -> Void
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    let user: User
    let currentLocation: Location
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            TabBarPageView(page: $page) {
                makeProfileView(flow: flow,
                                user: user,
                                accountService: apiService,
                                getReviewsService: apiService,
                                getPlaceDetailsService: placesService,
                                fetchPhotoService: placesService
                )
            }
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .settings:
                    makeSettingsView(flow: flow, logoutService: apiService)
                case .changePassword:
                    makeChangePasswordView(changePasswordService: apiService)
                case .editProfile:
                    makeEditProfileView(accountService: apiService)
                case let .placeDetails(placeDetails):
                    makeRestaurantDetailsView(flow: flow,
                                              placeDetails: placeDetails,
                                              currentLocation: currentLocation,
                                              getPlaceDetailsService: placesService,
                                              getReviewsService: apiService,
                                              fetchPhotoService: placesService)
                case let .addReview(placeID):
                    ReviewView(viewModel: ReviewViewModel(placeID: placeID, reviewService: apiService)) {
                        flow.navigateBack()
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func makeProfileView(
        flow: Flow<ProfileRoute>,
        user: User,
        accountService: AccountService,
        getReviewsService: GetReviewsService,
        getPlaceDetailsService: GetPlaceDetailsService,
        fetchPhotoService: FetchPlacePhotoService
    ) -> some View {
        ProfileView(
            viewModel: ProfileViewModel(
                accountService: accountService,
                getReviewsService: getReviewsService,
                user: user,
                goToLogin: goToLogin
            ),
            cell: { review in
                RestaurantReviewCellView(
                    viewModel: RestaurantReviewCellViewModel(
                        review: review,
                        getPlaceDetailsService: getPlaceDetailsService
                    ),
                    makePhotoView: { photoReference in
                        PhotoView(
                            viewModel: PhotoViewModel(
                                photoReference: photoReference,
                                fetchPhotoService: fetchPhotoService
                            )
                        )
                    },
                    showPlaceDetails: { placeDetails in
                        flow.append(.placeDetails(placeDetails))
                    }
                )
            },
            goToSettings: { flow.append(.settings) },
            goToEditProfile: { flow.append(.editProfile) }
        )
    }
    
    @ViewBuilder private func makeSettingsView(flow: Flow<ProfileRoute>, logoutService: LogoutService) -> some View {
        SettingsView(
            viewModel: SettingsViewModel(
                logoutService: logoutService,
                goToLogin: goToLogin
            )
        ) {
            flow.append(.changePassword)
        }
    }
    
    @ViewBuilder private func makeChangePasswordView(changePasswordService: ChangePasswordService) -> some View {
        ChangePasswordView(
            viewModel: ChangePasswordViewModel(changePasswordService: changePasswordService)
        )
    }
    
    @ViewBuilder private func makeEditProfileView(accountService: AccountService) -> some View {
        EditProfileView(
            viewModel: EditProfileViewModel(accountService: accountService)
        )
    }
    
    @ViewBuilder private func makeRestaurantDetailsView(
        flow: Flow<ProfileRoute>,
        placeDetails: PlaceDetails,
        currentLocation: Location,
        getPlaceDetailsService: GetPlaceDetailsService,
        getReviewsService: GetReviewsService,
        fetchPhotoService: FetchPlacePhotoService
    ) -> some View {
        RestaurantDetailsView(
            viewModel: RestaurantDetailsViewModel(
                input: .fetchedPlaceDetails(placeDetails),
                currentLocation: currentLocation,
                getPlaceDetailsService: getPlaceDetailsService,
                getReviewsService: getReviewsService
            ), makePhotoView: { photoReference in
                PhotoView(
                    viewModel: PhotoViewModel(
                        photoReference: photoReference,
                        fetchPhotoService: fetchPhotoService
                    )
                )
            }, showReviewView: {
                flow.append(.addReview(placeDetails.placeID))
            }
        )
    }
    
}
