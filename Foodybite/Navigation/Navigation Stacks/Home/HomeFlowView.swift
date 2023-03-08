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

struct HomeFlowView: View {
    @Binding var page: Page
    @ObservedObject var flow: Flow<HomeRoute>
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    let userPreferencesLoader: UserPreferencesLoader
    let userPreferencesSaver: UserPreferencesSaver
    let currentLocation: Location
    let searchNearbyDAO: SearchNearbyDAO
    
    var body: some View {
        NavigationStack(path: $flow.path) {
            TabBarPageView(page: $page) {
                makeHomeView()
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
    
    @ViewBuilder private func makeHomeView() -> some View {
        HomeView(
            viewModel: HomeViewModel(
                searchNearbyService: SearchNearbyServiceWithFallbackComposite(
                    primary: SearchNearbyServiceCacheDecorator(
                        searchNearbyService: placesService,
                        cache: searchNearbyDAO),
                    secondary: searchNearbyDAO),
                currentLocation: currentLocation,
                userPreferences: userPreferencesLoader.load()),
            showPlaceDetails: { placeID in
                flow.append(.placeDetails(placeID))
            },
            cell: { nearbyPlace in
                makeRestaurantCell(nearbyPlace: nearbyPlace,
                                   currentLocation: currentLocation,
                                   fetchPhotoService: placesService)
            },
            searchView: { searchText in
                makeHomeSearchView(searchText: searchText,
                                   userPreferences: userPreferencesLoader.load(),
                                   userPreferencesSaver: userPreferencesSaver)
            }
        )
    }
    
    @ViewBuilder private func makeRestaurantCell(
        nearbyPlace: NearbyPlace,
        currentLocation: Location,
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
                currentLocation: currentLocation
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
}
