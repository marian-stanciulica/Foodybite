//
//  RootView.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import SwiftUI
import Domain

struct RootView: View {
    private let rootFactory = RootFactory()
    @State var user: User?
    @StateObject var authflow = Flow<AuthRoute>()
    @StateObject var locationProvider = LocationProvider()
    
    var body: some View {
        HStack {
            if let user = user {
                if locationProvider.locationServicesEnabled {
                    makeTabNavigationView(user: user, locationProvider: locationProvider)
                } else {
                    TurnOnLocationView()
                }
            } else {
                makeAuthFlowView(loginService: rootFactory.apiService,
                                 signUpService: rootFactory.apiService) { user in
                    Task {
                        self.user = user
                        try? await rootFactory.userStore.write(user)
                    }
                }
            }
        }
        .task {
            self.user = try? await rootFactory.userStore.read()
        }
    }
    
    @ViewBuilder private func makeTabNavigationView(user: User, locationProvider: LocationProvider) -> some View {
        TabNavigationView(
            tabRouter: TabRouter(),
            apiService: rootFactory.authenticatedApiService,
            placesService: rootFactory.placesService,
            userPreferencesLoader: rootFactory.userPreferencesStore,
            userPreferencesSaver: rootFactory.userPreferencesStore,
            viewModel: TabNavigationViewModel(locationProvider: locationProvider),
            user: user,
            searchNearbyDAO: rootFactory.searchNearbyDAO
        )
    }
    
    @ViewBuilder private func makeAuthFlowView(
        loginService: LoginService,
        signUpService: SignUpService,
        goToMainTab: @escaping (User) -> Void)
    -> some View {
        NavigationStack(path: $authflow.path) {
            AuthFlowView.makeLoginView(
                flow: authflow,
                loginService: loginService,
                goToMainTab: goToMainTab
            )
            .navigationDestination(for: AuthRoute.self) { route in
                switch route {
                case .signUp:
                    makeRegisterView(signUpService: signUpService)
                }
            }
        }
    }
    
    @ViewBuilder private func makeRegisterView(signUpService: SignUpService) -> some View {
        RegisterView(viewModel: RegisterViewModel(signUpService: signUpService)) {
            authflow.navigateBack()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
