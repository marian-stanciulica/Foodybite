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

enum ProfileFlowView {
    
    @ViewBuilder static func makeProfileView(
        flow: Flow<ProfileRoute>,
        user: User,
        accountService: AccountService,
        getReviewsService: GetReviewsService,
        getPlaceDetailsService: RestaurantDetailsService,
        fetchPhotoService: RestaurantPhotoService,
        goToLogin: @escaping () -> Void
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
                                restaurantPhotoService: fetchPhotoService
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
    
    @ViewBuilder static func makeSettingsView(
        flow: Flow<ProfileRoute>,
        logoutService: LogoutService,
        goToLogin: @escaping () -> Void
    ) -> some View {
        SettingsView(
            viewModel: SettingsViewModel(
                logoutService: logoutService,
                goToLogin: goToLogin
            )
        ) {
            flow.append(.changePassword)
        }
    }
    
    @ViewBuilder static func makeChangePasswordView(changePasswordService: ChangePasswordService) -> some View {
        ChangePasswordView(
            viewModel: ChangePasswordViewModel(changePasswordService: changePasswordService)
        )
    }
    
    @ViewBuilder static func makeEditProfileView(accountService: AccountService) -> some View {
        EditProfileView(
            viewModel: EditProfileViewModel(accountService: accountService)
        )
    }
    
    @ViewBuilder static func makeRestaurantDetailsView(
        flow: Flow<ProfileRoute>,
        placeDetails: RestaurantDetails,
        currentLocation: Location,
        getPlaceDetailsService: RestaurantDetailsService,
        getReviewsService: GetReviewsService,
        fetchPhotoService: RestaurantPhotoService
    ) -> some View {
        RestaurantDetailsView(
            viewModel: RestaurantDetailsViewModel(
                input: .fetchedPlaceDetails(placeDetails),
                getDistanceInKmFromCurrentLocation: { referenceLocation in
                    DistanceSolver.getDistanceInKm(from: currentLocation, to: referenceLocation)
                },
                getPlaceDetailsService: getPlaceDetailsService,
                getReviewsService: getReviewsService
            ), makePhotoView: { photoReference in
                PhotoView(
                    viewModel: PhotoViewModel(
                        photoReference: photoReference,
                        restaurantPhotoService: fetchPhotoService
                    )
                )
            }, showReviewView: {
                flow.append(.addReview(placeDetails.placeID))
            }
        )
    }
    
    @ViewBuilder static func makeReviewView(
        flow: Flow<ProfileRoute>,
        placeID: String,
        addReviewService: AddReviewService
    ) -> some View {
        ReviewView(viewModel: ReviewViewModel(placeID: placeID, reviewService: addReviewService)) {
            flow.navigateBack()
        }
    }
    
}
