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
    @ObservedObject var flow: Flow<HomeRoute>
    let currentLocation: Location

    var body: some View {
        HomeView(
            viewModel: HomeViewModel(
                nearbyRestaurantsService: userAuthenticatedFactory.nearbyRestaurantsService,
                currentLocation: currentLocation,
                userPreferences: userAuthenticatedFactory.userPreferencesStore.load()),
            showRestaurantDetails: { restaurantID in
                flow.append(.restaurantDetails(restaurantID))
            },
            cell: { nearbyRestaurant in
                makeRestaurantCell(nearbyRestaurant: nearbyRestaurant,
                                   distanceInKmFromCurrentLocation:
                    DistanceSolver.getDistanceInKm(from: currentLocation, to: nearbyRestaurant.location),
                                   fetchPhotoService: userAuthenticatedFactory.placesService)
            },
            searchView: { searchText in
                makeHomeSearchView(searchText: searchText,
                                   userPreferences: userAuthenticatedFactory.userPreferencesStore.load(),
                                   userPreferencesSaver: userAuthenticatedFactory.userPreferencesStore)
            }
        )
    }

    @ViewBuilder private func makeRestaurantCell(
        nearbyRestaurant: NearbyRestaurant,
        distanceInKmFromCurrentLocation: Double,
        fetchPhotoService: RestaurantPhotoService
    ) -> some View {
        RestaurantCell(
            photoView: PhotoView(
                viewModel: PhotoViewModel(
                    photoReference: nearbyRestaurant.photo?.photoReference,
                    restaurantPhotoService: fetchPhotoService
                )
            ),
            viewModel: RestaurantCellViewModel(
                nearbyRestaurant: nearbyRestaurant,
                distanceInKmFromCurrentLocation: distanceInKmFromCurrentLocation
            )
        )
    }

    @ViewBuilder private func makeHomeSearchView(
        searchText: Binding<String>,
        userPreferences: UserPreferences,
        userPreferencesSaver: UserPreferencesSaver
    ) -> some View {
        HomeSearchView(
            searchText: searchText,
            searchCriteriaView: SearchCriteriaView(
                viewModel: SearchCriteriaViewModel(
                    userPreferences: userPreferences,
                    userPreferencesSaver: userPreferencesSaver)
            )
        )
    }

    @ViewBuilder static func makeRestaurantDetailsView(
        flow: Flow<HomeRoute>,
        restaurantID: String,
        currentLocation: Location,
        restaurantDetailsService: RestaurantDetailsService,
        getReviewsService: GetReviewsService,
        fetchPhotoService: RestaurantPhotoService
    ) -> some View {
        RestaurantDetailsView(
            viewModel: RestaurantDetailsViewModel(
                input: .restaurantIdToFetch(restaurantID),
                getDistanceInKmFromCurrentLocation: { referenceLocation in
                    DistanceSolver.getDistanceInKm(from: currentLocation, to: referenceLocation)
                },
                restaurantDetailsService: restaurantDetailsService,
                getReviewsService: getReviewsService
            ),
            makePhotoView: { photoReference in
                PhotoView(
                    viewModel: PhotoViewModel(
                        photoReference: photoReference,
                        restaurantPhotoService: fetchPhotoService
                    )
                )
            }, showReviewView: {
                flow.append(.addReview(restaurantID))
            }
        )
    }

    @ViewBuilder static func makeReviewView(
        flow: Flow<HomeRoute>,
        restaurantID: String,
        addReviewService: AddReviewService
    ) -> some View {
        ReviewView(
            viewModel: ReviewViewModel(
                restaurantID: restaurantID,
                reviewService: addReviewService
            ), dismissScreen: {
                flow.navigateBack()
            }
        )
    }
}
