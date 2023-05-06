//
//  AuthenticatedContainerView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import SwiftUI
import FoodybitePresentation
import FoodybiteLocation
import FoodybiteUI

struct UserAuthenticatedView: View {
    @Binding var loggedInUserID: String?
    let user: User
    @ObservedObject var locationProvider: LocationProvider

    private let userAuthenticatedFactory = UserAuthenticatedFactory()
    @StateObject var tabRouter = TabRouter()

    var body: some View {
        FetchLocationView(
            viewModel: FetchLocationViewModel(
                locationProvider: locationProvider),
            username: user.name,
            makeTabNavigationView: makeTabNavigationView
        )
    }

    @ViewBuilder private func makeTabNavigationView(location: Location) -> some View {
        switch tabRouter.currentPage {
        case .home:
            HomeFlowView(userAuthenticatedFactory: userAuthenticatedFactory,
                         currentLocation: location,
                         currentPage: $tabRouter.currentPage)
        case .newReview:
            makeNewReviewView(currentLocation: location)
        case .account:
            ProfileFlowView(userAuthenticatedFactory: userAuthenticatedFactory,
                            currentLocation: location,
                            user: user,
                            goToLogin: { loggedInUserID = nil },
                            currentPage: $tabRouter.currentPage)
        }
    }

    @ViewBuilder private func makeNewReviewView(currentLocation: Location) -> some View {
        TabBarPageView(page: $tabRouter.currentPage) {
            NewReviewView(
                viewModel: NewReviewViewModel(
                    autocompleteRestaurantsService: userAuthenticatedFactory.placesService,
                    restaurantDetailsService: userAuthenticatedFactory.restaurantDetailsService,
                    addReviewService: userAuthenticatedFactory.authenticatedApiService,
                    location: currentLocation,
                    userPreferences: userAuthenticatedFactory.userPreferencesStore.load()
                ),
                selectedView: { restaurantDetails in
                    SelectedRestaurantView(
                        photoView: PhotoView(
                            viewModel: PhotoViewModel(
                                photoReference: restaurantDetails.photos.first?.photoReference,
                                restaurantPhotoService: userAuthenticatedFactory.placesService
                            )
                        ),
                        restaurantDetails: restaurantDetails
                    )
                },
                dismissScreen: {
                    tabRouter.currentPage = .home
                }
            )
        }
    }
}

struct AuthenticatedContainerView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthenticatedView(
            loggedInUserID: .constant(nil),
            user: User(id: UUID(), name: "User", email: "user@user.com", profileImage: nil),
            locationProvider: LocationProvider()
        )
    }
}
