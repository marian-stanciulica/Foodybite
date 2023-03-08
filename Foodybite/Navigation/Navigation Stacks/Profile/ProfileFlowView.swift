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
                    EditProfileView(viewModel: EditProfileViewModel(accountService: apiService))
                case let .placeDetails(placeDetails):
                    RestaurantDetailsView(
                        viewModel: RestaurantDetailsViewModel(
                            input: .fetchedPlaceDetails(placeDetails),
                            currentLocation: currentLocation,
                            getPlaceDetailsService: placesService,
                            getReviewsService: apiService
                        ), makePhotoView: { photoReference in
                            PhotoView(
                                viewModel: PhotoViewModel(
                                    photoReference: photoReference,
                                    fetchPhotoService: placesService
                                )
                            )
                        }) {
                            flow.append(.addReview(placeDetails.placeID))
                        }
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
}
