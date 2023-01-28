//
//  FoodybiteApp.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

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
    @AppStorage("userLoggedIn") var userLoggedIn = false
    private let appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            if userLoggedIn {
                TabNavigationView(tabRouter: TabRouter(), apiService: appViewModel.makeAuthenticatedApiService(), placesService: appViewModel.makePlacesService())
            } else {
                AuthFlowView(userLoggedIn: $userLoggedIn,
                             apiService: appViewModel.makeApiService(),
                             flow: Flow<AuthRoute>())
            }
        }
    }
}
