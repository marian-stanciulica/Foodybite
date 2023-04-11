//
//  HomeFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import SwiftUI
import Domain
import FoodybitePresentation
import FoodybiteLocation
import FoodybiteUI

struct HomeFlowView: View {
    let userAuthenticatedFactory: UserAuthenticatedFactory
    let currentLocation: Location
    @Binding var currentPage: TabRouter.Page

    @StateObject var flow = Flow<HomeRoute>()

    var body: some View {
        NavigationStack(path: $flow.path) {
            TabBarPageView(page: $currentPage) {
                makeHomeView()
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .restaurantDetails(restaurantID):
                    makeRestaurantDetailsView(restaurantID: restaurantID)
                case let .addReview(restaurantID):
                    makeReviewView(restaurantID: restaurantID)
                }
            }
        }
    }

    @ViewBuilder private func makeHomeView() -> some View {
        HomeView(
            viewModel: HomeViewModel(
                nearbyRestaurantsService: userAuthenticatedFactory.nearbyRestaurantsService,
                currentLocation: currentLocation,
                userPreferences: userAuthenticatedFactory.userPreferencesStore.load()),
            showRestaurantDetails: { restaurantID in
                flow.append(.restaurantDetails(restaurantID))
            },
            cell: makeRestaurantCell,
            searchView: makeHomeSearchView
        )
    }

    @ViewBuilder private func makeRestaurantCell(nearbyRestaurant: NearbyRestaurant) -> some View {
        RestaurantCell(
            photoView: PhotoView(
                viewModel: PhotoViewModel(
                    photoReference: nearbyRestaurant.photo?.photoReference,
                    restaurantPhotoService: userAuthenticatedFactory.placesService
                )
            ),
            viewModel: RestaurantCellViewModel(
                nearbyRestaurant: nearbyRestaurant,
                distanceInKmFromCurrentLocation: DistanceSolver.getDistanceInKm(from: currentLocation, to: nearbyRestaurant.location)
            )
        )
    }

    @ViewBuilder private func makeHomeSearchView(searchText: Binding<String>) -> some View {
        HomeSearchView(
            searchText: searchText,
            searchCriteriaView: SearchCriteriaView(
                viewModel: SearchCriteriaViewModel(
                    userPreferences: userAuthenticatedFactory.userPreferencesStore.load(),
                    userPreferencesSaver: userAuthenticatedFactory.userPreferencesStore)
            )
        )
    }

    @ViewBuilder private func makeRestaurantDetailsView(restaurantID: String) -> some View {
        RestaurantDetailsView(
            viewModel: RestaurantDetailsViewModel(
                input: .restaurantIdToFetch(restaurantID),
                getDistanceInKmFromCurrentLocation: { referenceLocation in
                    DistanceSolver.getDistanceInKm(from: currentLocation, to: referenceLocation)
                },
                restaurantDetailsService: userAuthenticatedFactory.restaurantDetailsService,
                getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite
            ),
            makePhotoView: { photoReference in
                PhotoView(
                    viewModel: PhotoViewModel(
                        photoReference: photoReference,
                        restaurantPhotoService: userAuthenticatedFactory.placesService
                    )
                )
            }, showReviewView: {
                flow.append(.addReview(restaurantID))
            }
        )
    }

    @ViewBuilder private func makeReviewView(restaurantID: String) -> some View {
        ReviewView(
            viewModel: ReviewViewModel(
                restaurantID: restaurantID,
                reviewService: userAuthenticatedFactory.authenticatedApiService
            ), dismissScreen: {
                flow.navigateBack()
            }
        )
    }
}
