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
import FoodybitePresentation
import FoodybiteLocation
import FoodybiteUI

struct ProfileFlowView: View {
    let userAuthenticatedFactory: UserAuthenticatedFactory
    let currentLocation: Location
    let user: User
    let goToLogin: () -> Void
    @Binding var currentPage: TabRouter.Page
    @StateObject var flow = Flow<ProfileRoute>()

    var body: some View {
        NavigationStack(path: $flow.path) {
            TabBarPageView(page: $currentPage) {
                makeProfileView()
            }
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .settings:
                    makeSettingsView()
                case .changePassword:
                    makeChangePasswordView()
                case .editProfile:
                    makeEditProfileView()
                case let .restaurantDetails(restaurantDetails):
                    makeRestaurantDetailsView(restaurantDetails: restaurantDetails)
                case let .addReview(restaurantID):
                    makeReviewView(restaurantID: restaurantID)
                }
            }
        }
    }

    @ViewBuilder private func makeProfileView() -> some View {
        ProfileView(
            viewModel: ProfileViewModel(
                accountService: userAuthenticatedFactory.authenticatedApiService,
                getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite,
                user: user,
                goToLogin: goToLogin
            ),
            cell: { review in
                RestaurantReviewCellView(
                    viewModel: RestaurantReviewCellViewModel(
                        review: review,
                        restaurantDetailsService: userAuthenticatedFactory.restaurantDetailsService
                    ),
                    makePhotoView: { photoReference in
                        PhotoView(
                            viewModel: PhotoViewModel(
                                photoReference: photoReference,
                                restaurantPhotoService: userAuthenticatedFactory.placesService
                            )
                        )
                    },
                    showRestaurantDetails: {
                        flow.append(.restaurantDetails($0))
                    }
                )
            },
            goToSettings: { flow.append(.settings) },
            goToEditProfile: { flow.append(.editProfile) }
        )
    }

    @ViewBuilder private func makeSettingsView() -> some View {
        SettingsView(
            viewModel: SettingsViewModel(
                logoutService: userAuthenticatedFactory.authenticatedApiService,
                goToLogin: goToLogin
            )
        ) {
            flow.append(.changePassword)
        }
    }

    @ViewBuilder private func makeChangePasswordView() -> some View {
        ChangePasswordView(
            viewModel: ChangePasswordViewModel(changePasswordService: userAuthenticatedFactory.authenticatedApiService)
        )
    }

    @ViewBuilder private func makeEditProfileView() -> some View {
        EditProfileView(
            viewModel: EditProfileViewModel(accountService: userAuthenticatedFactory.authenticatedApiService)
        )
    }

    @ViewBuilder private func makeRestaurantDetailsView(restaurantDetails: RestaurantDetails) -> some View {
        RestaurantDetailsView(
            viewModel: RestaurantDetailsViewModel(
                input: .fetchedRestaurantDetails(restaurantDetails),
                getDistanceInKmFromCurrentLocation: { referenceLocation in
                    DistanceSolver.getDistanceInKm(from: currentLocation, to: referenceLocation)
                },
                restaurantDetailsService: userAuthenticatedFactory.restaurantDetailsService,
                getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite
            ), makePhotoView: { photoReference in
                PhotoView(
                    viewModel: PhotoViewModel(
                        photoReference: photoReference,
                        restaurantPhotoService: userAuthenticatedFactory.placesService
                    )
                )
            }, showReviewView: {
                flow.append(.addReview(restaurantDetails.id))
            }
        )
    }

    @ViewBuilder private func makeReviewView(restaurantID: String) -> some View {
        ReviewView(viewModel: ReviewViewModel(restaurantID: restaurantID, reviewService: userAuthenticatedFactory.authenticatedApiService)) {
            flow.navigateBack()
        }
    }

}
