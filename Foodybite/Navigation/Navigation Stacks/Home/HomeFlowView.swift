//
//  HomeFlowView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import SwiftUI
import Domain
import FoodybiteNetworking
import FoodybitePlaces
import FoodybitePersistence
import FoodybitePresentation
import FoodybiteLocation
import FoodybiteUI

enum HomeFlowView {
    
    @ViewBuilder static func makeHomeView(
        flow: Flow<HomeRoute>,
        currentLocation: Location,
        computeDistanceInKmFromCurrentLocation: @escaping (Location) -> Double,
        userPreferences: UserPreferences,
        userPreferencesSaver: UserPreferencesSaver,
        searchNearbyService: SearchNearbyService,
        fetchPhotoService: FetchPlacePhotoService
    ) -> some View {
        HomeView(
            viewModel: HomeViewModel(
                searchNearbyService: searchNearbyService,
                currentLocation: currentLocation,
                userPreferences: userPreferences),
            showPlaceDetails: { placeID in
                flow.append(.placeDetails(placeID))
            },
            cell: { nearbyPlace in
                makeRestaurantCell(nearbyPlace: nearbyPlace,
                                   distanceInKmFromCurrentLocation: computeDistanceInKmFromCurrentLocation(nearbyPlace.location),
                                   fetchPhotoService: fetchPhotoService)
            },
            searchView: { searchText in
                makeHomeSearchView(searchText: searchText,
                                   userPreferences: userPreferences,
                                   userPreferencesSaver: userPreferencesSaver)
            }
        )
    }
    
    @ViewBuilder private static func makeRestaurantCell(
        nearbyPlace: NearbyPlace,
        distanceInKmFromCurrentLocation: Double,
        fetchPhotoService: FetchPlacePhotoService
    ) -> some View {
        RestaurantCell(
            photoView: PhotoView(
                viewModel: PhotoViewModel(
                    photoReference: nearbyPlace.photo?.photoReference,
                    fetchPhotoService: fetchPhotoService
                )
            ),
            viewModel: RestaurantCellViewModel(
                nearbyPlace: nearbyPlace,
                distanceInKmFromCurrentLocation: distanceInKmFromCurrentLocation
            )
        )
    }
    
    @ViewBuilder private static func makeHomeSearchView(
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
        placeID: String,
        currentLocation: Location,
        getPlaceDetailsService: GetPlaceDetailsService,
        getReviewsService: GetReviewsService,
        fetchPhotoService: FetchPlacePhotoService
    ) -> some View {
        RestaurantDetailsView(
            viewModel: RestaurantDetailsViewModel(
                input: .placeIdToFetch(placeID),
                getDistanceInKmFromCurrentLocation: { referenceLocation in
                    DistanceSolver.getDistanceInKm(from: currentLocation, to: referenceLocation)
                },
                getPlaceDetailsService: getPlaceDetailsService,
                getReviewsService: getReviewsService
            ),
            makePhotoView: { photoReference in
                PhotoView(
                    viewModel: PhotoViewModel(
                        photoReference: photoReference,
                        fetchPhotoService: fetchPhotoService
                    )
                )
            }, showReviewView: {
                flow.append(.addReview(placeID))
            }
        )
    }
    
    @ViewBuilder static func makeReviewView(
        flow: Flow<HomeRoute>,
        placeID: String,
        addReviewService: AddReviewService
    ) -> some View {
        ReviewView(
            viewModel: ReviewViewModel(
                placeID: placeID,
                reviewService: addReviewService
            ), dismissScreen: {
                flow.navigateBack()
            }
        )
    }
}
