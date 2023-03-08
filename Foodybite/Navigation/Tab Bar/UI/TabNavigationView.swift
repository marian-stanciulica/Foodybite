//
//  TabNavigationView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking
import FoodybitePlaces
import Domain
import FoodybitePersistence

struct TabNavigationView: View {
    @StateObject var tabRouter: TabRouter
    @State var plusButtonActive = false
    let apiService: FoodybiteNetworking.APIService
    let placesService: FoodybitePlaces.APIService
    let userPreferencesLoader: UserPreferencesLoader
    let userPreferencesSaver: UserPreferencesSaver
    @StateObject var viewModel: TabNavigationViewModel
    let user: User
    let searchNearbyDAO: SearchNearbyDAO
    @AppStorage("userLoggedIn") var userLoggedIn = false
    
    @ObservedObject var homeflow = Flow<HomeRoute>()
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .isLoading:
                ProgressView()
                
            case let .failure(error):
                Text(error.rawValue)
                
            case let .success(location):
                switch tabRouter.currentPage {
                case .home:
                    makeHomeFlowView(location: location)
                case .newReview:
                    TabBarPageView(page: $tabRouter.currentPage) {
                        NewReviewView(
                            currentPage: $tabRouter.currentPage,
                            plusButtonActive: $plusButtonActive,
                            viewModel: NewReviewViewModel(
                                autocompletePlacesService: placesService,
                                getPlaceDetailsService: placesService,
                                addReviewService: apiService,
                                location: location,
                                userPreferences: userPreferencesLoader.load()
                            ),
                            selectedView: { placeDetails in
                                SelectedRestaurantView(
                                    photoView: PhotoView(
                                        viewModel: PhotoViewModel(
                                            photoReference: placeDetails.photos.first?.photoReference,
                                            fetchPhotoService: placesService
                                        )
                                    ),
                                    placeDetails: placeDetails
                                )
                            }
                        )
                    }
                case .account:
                    ProfileFlowView(page: $tabRouter.currentPage, flow: Flow<ProfileRoute>(), goToLogin: { userLoggedIn = false }, apiService: apiService, placesService: placesService, user: user, currentLocation: location)
                }
            }
        }
        .task {
            await viewModel.getCurrentLocation()
        }
    }
    
    @ViewBuilder private func makeHomeFlowView(location: Location) -> some View {
        NavigationStack(path: $homeflow.path) {
            TabBarPageView(page: $tabRouter.currentPage) {
                HomeFlowView.makeHomeView(
                    flow: homeflow,
                    currentLocation: location,
                    userPreferences: userPreferencesLoader.load(),
                    userPreferencesSaver: userPreferencesSaver,
                    searchNearbyService: SearchNearbyServiceWithFallbackComposite(
                        primary: SearchNearbyServiceCacheDecorator(
                            searchNearbyService: placesService,
                            cache: searchNearbyDAO),
                        secondary: searchNearbyDAO
                    ),
                    fetchPhotoService: placesService
                )
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .placeDetails(placeID):
                    HomeFlowView.makeRestaurantDetailsView(
                        flow: homeflow,
                        placeID: placeID,
                        currentLocation: location,
                        getPlaceDetailsService: placesService,
                        getReviewsService: apiService,
                        fetchPhotoService: placesService
                    )
                case let .addReview(placeID):
                    HomeFlowView.makeReviewView(
                        flow: homeflow,
                        placeID: placeID,
                        addReviewService: apiService
                    )
                }
            }
        }
    }
}
