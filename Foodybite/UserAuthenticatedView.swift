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
    @StateObject var viewModel: UserAuthenticatedViewModel

    private let userAuthenticatedFactory = UserAuthenticatedFactory()
    @StateObject var tabRouter = TabRouter()
    @StateObject var homeFlow = Flow<HomeRoute>()
    @StateObject var profileFlow = Flow<ProfileRoute>()
    
    @State var plusButtonActive = false
    
    var body: some View {
        if locationProvider.locationServicesEnabled {
            makeTabNavigationView()
            .task {
                await viewModel.getCurrentLocation()
            }
        } else {
            TurnOnLocationView()
        }
    }
    
    @ViewBuilder private func makeTabNavigationView() -> some View {
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
        NavigationStack(path: $homeFlow.path) {
            TabBarPageView(page: $tabRouter.currentPage) {
                HomeFlowView.makeHomeView(
                    flow: homeFlow,
                    currentLocation: currentLocation,
                    computeDistanceInKmFromCurrentLocation: { referenceLocation in
                        DistanceSolver.getDistanceInKm(from: currentLocation, to: referenceLocation)
                    },
                    userPreferences: userAuthenticatedFactory.userPreferencesStore.load(),
                    userPreferencesSaver: userAuthenticatedFactory.userPreferencesStore,
                    nearbyRestaurantsService: userAuthenticatedFactory.nearbyRestaurantsServiceWithFallbackComposite,
                    fetchPhotoService: userAuthenticatedFactory.placesService
                )
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .placeDetails(placeID):
                    HomeFlowView.makeRestaurantDetailsView(
                        flow: homeFlow,
                        placeID: placeID,
                        currentLocation: currentLocation,
                        getPlaceDetailsService: userAuthenticatedFactory.getPlaceDetailsWithFallbackComposite,
                        getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite,
                        fetchPhotoService: userAuthenticatedFactory.placesService
                    )
                case let .addReview(placeID):
                    HomeFlowView.makeReviewView(
                        flow: homeFlow,
                        placeID: placeID,
                        addReviewService: userAuthenticatedFactory.authenticatedApiService
                    )
                }
            }
        }
    }
    
    @ViewBuilder private func makeNewReviewView(currentLocation: Location) -> some View {
        TabBarPageView(page: $tabRouter.currentPage) {
            NewReviewView(
                plusButtonActive: $plusButtonActive,
                viewModel: NewReviewViewModel(
                    autocompletePlacesService: userAuthenticatedFactory.placesService,
                    getPlaceDetailsService: userAuthenticatedFactory.getPlaceDetailsWithFallbackComposite,
                    addReviewService: userAuthenticatedFactory.authenticatedApiService,
                    location: currentLocation,
                    userPreferences: userAuthenticatedFactory.userPreferencesStore.load()
                ),
                selectedView: { placeDetails in
                    SelectedRestaurantView(
                        photoView: PhotoView(
                            viewModel: PhotoViewModel(
                                photoReference: placeDetails.photos.first?.photoReference,
                                restaurantPhotoService: userAuthenticatedFactory.placesService
                            )
                        ),
                        placeDetails: placeDetails
                    )
                }
            )
        }
    }
    
    @ViewBuilder private func makeProfileFlowView(currentLocation: Location) -> some View {
        NavigationStack(path: $profileFlow.path) {
            TabBarPageView(page: $tabRouter.currentPage) {
                ProfileFlowView.makeProfileView(
                    flow: profileFlow,
                    user: user,
                    accountService: userAuthenticatedFactory.authenticatedApiService,
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
                        flow: profileFlow,
                        logoutService: userAuthenticatedFactory.authenticatedApiService,
                        goToLogin: { loggedInUserID = nil }
                    )
                case .changePassword:
                    ProfileFlowView.makeChangePasswordView(changePasswordService: userAuthenticatedFactory.authenticatedApiService)
                case .editProfile:
                    ProfileFlowView.makeEditProfileView(accountService: userAuthenticatedFactory.authenticatedApiService)
                case let .placeDetails(placeDetails):
                    ProfileFlowView.makeRestaurantDetailsView(
                        flow: profileFlow,
                        placeDetails: placeDetails,
                        currentLocation: currentLocation,
                        getPlaceDetailsService: userAuthenticatedFactory.getPlaceDetailsWithFallbackComposite,
                        getReviewsService: userAuthenticatedFactory.getReviewsWithFallbackComposite,
                        fetchPhotoService: userAuthenticatedFactory.placesService
                    )
                case let .addReview(placeID):
                    ProfileFlowView.makeReviewView(
                        flow: profileFlow,
                        placeID: placeID,
                        addReviewService: userAuthenticatedFactory.authenticatedApiService
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
