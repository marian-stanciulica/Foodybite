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
    
    @StateObject var homeflow = Flow<HomeRoute>()
    @StateObject var profileflow = Flow<ProfileRoute>()
    
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
                    makeHomeFlowView(currentLocation: location)
                case .newReview:
                    makeNewReviewView(currentLocation: location)
                case .account:
                    makeProfileFlowView(currentLocation: location)
                }
            }
        }
        .task {
            await viewModel.getCurrentLocation()
        }
    }
    
    @ViewBuilder private func makeHomeFlowView(currentLocation: Location) -> some View {
        NavigationStack(path: $homeflow.path) {
            TabBarPageView(page: $tabRouter.currentPage) {
                HomeFlowView.makeHomeView(
                    flow: homeflow,
                    currentLocation: currentLocation,
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
                        currentLocation: currentLocation,
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
    
    @ViewBuilder private func makeNewReviewView(currentLocation: Location) -> some View {
        TabBarPageView(page: $tabRouter.currentPage) {
            NewReviewView(
                currentPage: $tabRouter.currentPage,
                plusButtonActive: $plusButtonActive,
                viewModel: NewReviewViewModel(
                    autocompletePlacesService: placesService,
                    getPlaceDetailsService: placesService,
                    addReviewService: apiService,
                    location: currentLocation,
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
    }
    
    @ViewBuilder private func makeProfileFlowView(currentLocation: Location) -> some View {
        NavigationStack(path: $profileflow.path) {
            TabBarPageView(page: $tabRouter.currentPage) {
                ProfileFlowView.makeProfileView(
                    flow: profileflow,
                    user: user,
                    accountService: apiService,
                    getReviewsService: apiService,
                    getPlaceDetailsService: placesService,
                    fetchPhotoService: placesService,
                    goToLogin: { userLoggedIn = false }
                )
            }
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .settings:
                    ProfileFlowView.makeSettingsView(
                        flow: profileflow,
                        logoutService: apiService,
                        goToLogin: { userLoggedIn = false }
                    )
                case .changePassword:
                    ProfileFlowView.makeChangePasswordView(changePasswordService: apiService)
                case .editProfile:
                    ProfileFlowView.makeEditProfileView(accountService: apiService)
                case let .placeDetails(placeDetails):
                    ProfileFlowView.makeRestaurantDetailsView(
                        flow: profileflow,
                        placeDetails: placeDetails,
                        currentLocation: currentLocation,
                        getPlaceDetailsService: placesService,
                        getReviewsService: apiService,
                        fetchPhotoService: placesService
                    )
                case let .addReview(placeID):
                    ProfileFlowView.makeReviewView(
                        flow: profileflow,
                        placeID: placeID,
                        addReviewService: apiService
                    )
                }
            }
        }
    }
    
}
