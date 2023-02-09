//
//  FoodybiteApp.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Domain
import SwiftUI
import FoodybiteNetworking
import FoodybitePlaces

final class AppViewModel {
    func makeApiService() -> FoodybiteNetworking.APIService {
        let httpClient = FoodybiteNetworking.URLSessionHTTPClient()
        let tokenStore = KeychainTokenStore()
        
        let remoteResourceLoader = RemoteResourceLoader(client: httpClient)
        return APIService(loader: remoteResourceLoader,
                          sender: remoteResourceLoader,
                          tokenStore: tokenStore)
    }
    
    func makeAuthenticatedApiService() -> FoodybiteNetworking.APIService {
        let httpClient = FoodybiteNetworking.URLSessionHTTPClient()
        let refreshTokenLoader = RemoteResourceLoader(client: httpClient)
        let tokenStore = KeychainTokenStore()
                
        let tokenRefresher = RefreshTokenService(loader: refreshTokenLoader, tokenStore: tokenStore)
        let authenticatedHTTPClient = AuthenticatedURLSessionHTTPClient(decoratee: httpClient, tokenRefresher: tokenRefresher)
        let authenticatedRemoteResourceLoader = RemoteResourceLoader(client: authenticatedHTTPClient)
        
        return APIService(loader: authenticatedRemoteResourceLoader,
                          sender: authenticatedRemoteResourceLoader,
                          tokenStore: tokenStore)
    }
    
    func makePlacesService() -> FoodybitePlaces.APIService {
        let httpClient = FoodybitePlaces.URLSessionHTTPClient()
        let loader = FoodybitePlaces.RemoteResourceLoader(client: httpClient)
        return FoodybitePlaces.APIService(loader: loader)
    }
}

@main
struct FoodybiteApp: App {
    private let appViewModel = AppViewModel()
    @AppStorage("userLoggedIn") var userLoggedIn = false
    @State var user: User?
    
    var body: some Scene {
        WindowGroup {
            if let user = user, userLoggedIn {
                LocationCheckView { locationProvider in
                    TabNavigationView(
                        tabRouter: TabRouter(),
                        apiService: appViewModel.makeAuthenticatedApiService(),
                        placesService: appViewModel.makePlacesService(),
                        viewModel: TabNavigationViewModel(locationProvider: locationProvider),
                        user: user)
                }
            } else {
                AuthFlowView(flow: Flow<AuthRoute>(), apiService: appViewModel.makeApiService()) { user in
                    self.user = user
                    userLoggedIn = true
                }
            }
        }
    }
}
