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
    @AppStorage("userLoggedIn") var userLoggedIn = false
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    let user: User
    let currentLocation: Location
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            TabBarPageView(page: $page) {
                ProfileView(
                    viewModel: ProfileViewModel(
                        accountService: apiService,
                        getReviewsService: apiService,
                        user: user,
                        goToLogin: { userLoggedIn = false }
                    ),
                    cell: { review in
                        RestaurantReviewCellView(
                            viewModel: RestaurantReviewCellViewModel(
                                review: review,
                                getPlaceDetailsService: placesService,
                                fetchPlacePhotoService: placesService
                            ),
                            showPlaceDetails: { placeDetails in
                                flow.append(.placeDetails(placeDetails))
                            }
                        )
                    },
                    goToSettings: { flow.append(.settings) },
                    goToEditProfile: { flow.append(.editProfile) }
                )
            }
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .settings:
                    SettingsView(
                        viewModel: SettingsViewModel(
                            logoutService: apiService,
                            goToLogin: { userLoggedIn = false }
                        )
                    ) {
                        flow.append(.changePassword)
                    }
                case .changePassword:
                    ChangePasswordView(viewModel: ChangePasswordViewModel(changePasswordService: apiService))
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
}
