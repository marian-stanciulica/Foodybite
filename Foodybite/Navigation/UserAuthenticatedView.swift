//
//  AuthenticatedContainerView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain
import SwiftUI

struct UserAuthenticatedView: View {
    private let userAuthenticatedFactory = UserAuthenticatedFactory()
    let user: User
    @StateObject var tabRouter = TabRouter()
    @ObservedObject var locationProvider: LocationProvider

    var body: some View {
        if locationProvider.locationServicesEnabled {
            makeTabNavigationView(user: user, locationProvider: locationProvider)
        } else {
            TurnOnLocationView()
        }
    }
    
    @ViewBuilder private func makeTabNavigationView(user: User, locationProvider: LocationProvider) -> some View {
        TabNavigationView(
            tabRouter: tabRouter,
            apiService: userAuthenticatedFactory.authenticatedApiService,
            placesService: userAuthenticatedFactory.placesService,
            userPreferencesLoader: userAuthenticatedFactory.userPreferencesStore,
            userPreferencesSaver: userAuthenticatedFactory.userPreferencesStore,
            viewModel: TabNavigationViewModel(locationProvider: locationProvider),
            user: user,
            searchNearbyDAO: userAuthenticatedFactory.searchNearbyDAO
        )
    }
}

struct AuthenticatedContainerView_Previews: PreviewProvider {
    static var previews: some View {
        UserAuthenticatedView(
            user: User(id: UUID(), name: "User", email: "user@user.com", profileImage: nil),
            locationProvider: LocationProvider()
        )
    }
}
