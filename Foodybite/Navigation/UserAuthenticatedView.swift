//
//  AuthenticatedContainerView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import SwiftUI

struct UserAuthenticatedView: View {
    @Binding var loggedInUserID: String?
    let user: User
    @ObservedObject var locationProvider: LocationProvider
    @StateObject var viewModel: UserAuthenticatedViewModel

    private let userAuthenticatedFactory = UserAuthenticatedFactory()
    @StateObject var tabRouter = TabRouter()
    @StateObject var homeflow = Flow<HomeRoute>()
    @StateObject var profileflow = Flow<ProfileRoute>()
    
    @State var plusButtonActive = false
    
    var body: some View {
        if locationProvider.locationServicesEnabled {
            makeTabNavigationView(
                user: user,
                locationProvider: locationProvider
            )
            .task {
                await viewModel.getCurrentLocation()
            }
        } else {
            TurnOnLocationView()
        }
    }
    
    @ViewBuilder private func makeTabNavigationView(user: User, locationProvider: LocationProvider) -> some View {
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
    
    @ViewBuilder private func makeHomeFlowView(currentLocation: Location) -> some View {
        NavigationStack(path: $homeflow.path) {
            TabBarPageView(page: $tabRouter.currentPage) {
                HomeFlowView.makeHomeView(
                    flow: homeflow,
                    currentLocation: currentLocation,
                    userPreferences: userAuthenticatedFactory.userPreferencesStore.load(),
                    userPreferencesSaver: userAuthenticatedFactory.userPreferencesStore,
                    searchNearbyService: SearchNearbyServiceWithFallbackComposite(
                        primary: SearchNearbyServiceCacheDecorator(
                            searchNearbyService: userAuthenticatedFactory.placesService,
                            cache: userAuthenticatedFactory.searchNearbyDAO
                        ),
                        secondary: userAuthenticatedFactory.searchNearbyDAO
                    ),
                    fetchPhotoService: userAuthenticatedFactory.placesService
                )
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .placeDetails(placeID):
                    HomeFlowView.makeRestaurantDetailsView(
                        flow: homeflow,
                        placeID: placeID,
                        currentLocation: currentLocation,
                        getPlaceDetailsService: userAuthenticatedFactory.getPlaceDetailsWithFallbackComposite,
                        getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite,
                        fetchPhotoService: userAuthenticatedFactory.placesService
                    )
                case let .addReview(placeID):
                    HomeFlowView.makeReviewView(
                        flow: homeflow,
                        placeID: placeID,
                        addReviewService: userAuthenticatedFactory.apiService
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
                    autocompletePlacesService: userAuthenticatedFactory.placesService,
                    getPlaceDetailsService: userAuthenticatedFactory.getPlaceDetailsWithFallbackComposite,
                    addReviewService: userAuthenticatedFactory.apiService,
                    location: currentLocation,
                    userPreferences: userAuthenticatedFactory.userPreferencesStore.load()
                ),
                selectedView: { placeDetails in
                    SelectedRestaurantView(
                        photoView: PhotoView(
                            viewModel: PhotoViewModel(
                                photoReference: placeDetails.photos.first?.photoReference,
                                fetchPhotoService: userAuthenticatedFactory.placesService
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
                    accountService: userAuthenticatedFactory.apiService,
                    getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite,
                    getPlaceDetailsService: userAuthenticatedFactory.getPlaceDetailsWithFallbackComposite,
                    fetchPhotoService: userAuthenticatedFactory.placesService,
                    goToLogin: { loggedInUserID = nil }
                )
            }
            .navigationDestination(for: ProfileRoute.self) { route in
                switch route {
                case .settings:
                    ProfileFlowView.makeSettingsView(
                        flow: profileflow,
                        logoutService: userAuthenticatedFactory.apiService,
                        goToLogin: { loggedInUserID = nil }
                    )
                case .changePassword:
                    ProfileFlowView.makeChangePasswordView(changePasswordService: userAuthenticatedFactory.apiService)
                case .editProfile:
                    ProfileFlowView.makeEditProfileView(accountService: userAuthenticatedFactory.apiService)
                case let .placeDetails(placeDetails):
                    ProfileFlowView.makeRestaurantDetailsView(
                        flow: profileflow,
                        placeDetails: placeDetails,
                        currentLocation: currentLocation,
                        getPlaceDetailsService: userAuthenticatedFactory.getPlaceDetailsWithFallbackComposite,
                        getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite,
                        fetchPhotoService: userAuthenticatedFactory.placesService
                    )
                case let .addReview(placeID):
                    ProfileFlowView.makeReviewView(
                        flow: profileflow,
                        placeID: placeID,
                        addReviewService: userAuthenticatedFactory.apiService
                    )
                }
            }
        }
    }
}

struct AuthenticatedContainerView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthenticatedView(
            loggedInUserID: .constant(nil),
            user: User(id: UUID(), name: "User", email: "user@user.com", profileImage: nil),
            locationProvider: LocationProvider(),
            viewModel: UserAuthenticatedViewModel(locationProvider: LocationProvider())
        )
    }
}
