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
                makeHomeView(currentLocation: currentLocation,
                             userPreferences: userPreferencesLoader.load(),
                             userPreferencesSaver: userPreferencesSaver,
                             searchNearbyService: placesService,
                             fetchPhotoService: placesService)
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .placeDetails(placeID):
                    makeRestaurantDetailsView(placeID: placeID,
                                              currentLocation: currentLocation,
                                              getPlaceDetailsService: placesService,
                                              getReviewsService: apiService,
                                              fetchPhotoService: placesService)
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
    
    @ViewBuilder private func makeHomeView(
        currentLocation: Location,
        userPreferences: UserPreferences,
        userPreferencesSaver: UserPreferencesSaver,
        searchNearbyService: SearchNearbyService,
        fetchPhotoService: FetchPlacePhotoService
    ) -> some View {
        HomeView(
            viewModel: HomeViewModel(
                searchNearbyService: SearchNearbyServiceWithFallbackComposite(
                    primary: SearchNearbyServiceCacheDecorator(
                        searchNearbyService: searchNearbyService,
                        cache: searchNearbyDAO),
                    secondary: searchNearbyDAO),
                currentLocation: currentLocation,
                userPreferences: userPreferences),
            showPlaceDetails: { placeID in
                flow.append(.placeDetails(placeID))
            },
            cell: { nearbyPlace in
                makeRestaurantCell(nearbyPlace: nearbyPlace,
                                   currentLocation: currentLocation,
                                   fetchPhotoService: fetchPhotoService)
            },
            searchView: { searchText in
                makeHomeSearchView(searchText: searchText,
                                   userPreferences: userPreferences,
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
    
    @ViewBuilder private func makeRestaurantDetailsView(
        placeID: String,
        currentLocation: Location,
        getPlaceDetailsService: GetPlaceDetailsService,
        getReviewsService: GetReviewsService,
        fetchPhotoService: FetchPlacePhotoService
    ) -> some View {
        RestaurantDetailsView(
            viewModel: RestaurantDetailsViewModel(
                input: .placeIdToFetch(placeID),
                currentLocation: currentLocation,
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
}
