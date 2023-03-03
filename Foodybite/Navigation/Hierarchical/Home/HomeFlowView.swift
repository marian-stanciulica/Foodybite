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

struct HomeFlowView: View {
    @Binding var page: Page
    @ObservedObject var flow: Flow<HomeRoute>
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    let userPreferencesLoader: UserPreferencesLoader
    let userPreferencesSaver: UserPreferencesSaver
    let currentLocation: Location
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            TabBarPageView(page: $page) {
                HomeView(
                    viewModel: HomeViewModel(
                        searchNearbyService: placesService,
                        currentLocation: currentLocation),
                    showPlaceDetails: { placeID in
                        flow.append(.placeDetails(placeID))
                    },
                    cell: { nearbyPlace in
                        RestaurantCell(
                            photoView: PhotoView(
                                viewModel: PhotoViewModel(
                                    photoReference: nearbyPlace.photo?.photoReference,
                                    fetchPhotoService: placesService
                                )
                            ),
                            viewModel: RestaurantCellViewModel(
                                nearbyPlace: nearbyPlace,
                                currentLocation: currentLocation
                            )
                        )
                    },
                    searchView: AnyView(
                        HomeSearchView(
                            searchText: .constant(""),
                            searchCriteriaView: AnyView(
                                SearchCriteriaView(
                                    viewModel: SearchCriteriaViewModel(
                                        userPreferences: userPreferencesLoader.load(),
                                        userPreferencesSaver: userPreferencesSaver)
                                )
                            )
                        )
                    )
                )
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .placeDetails(placeID):
                    RestaurantDetailsView(
                        viewModel: RestaurantDetailsViewModel(
                            input: .placeIdToFetch(placeID),
                            currentLocation: currentLocation,
                            getPlaceDetailsService: placesService,
                            getReviewsService: apiService
                        ),
                        makePhotoView: { photoReference in
                            PhotoView(
                                viewModel: PhotoViewModel(
                                    photoReference: photoReference,
                                    fetchPhotoService: placesService
                                )
                            )
                        }, showReviewView: {
                            flow.append(.addReview(placeID))
                        }
                    )
                case let .addReview(placeID):
                    ReviewView(
                        viewModel: ReviewViewModel(
                            placeID: placeID,
                            reviewService: apiService
                        ), dismissScreen: {
                            flow.navigateBack()
                        }
                    )
                }
            }
        }
    }
}
