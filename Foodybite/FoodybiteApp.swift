//
//  FoodybiteApp.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import SwiftUI
import FoodybiteNetworking
import FoodybitePlaces

@main
struct FoodybiteApp: App {
    @AppStorage("userLoggedIn") var userLoggedIn = false
    
    var body: some Scene {
        let httpClient = URLSessionHTTPClient()
        let refreshTokenLoader = RemoteResourceLoader(client: httpClient)
        let tokenStore = KeychainTokenStore()
        
        let remoteResourceLoader = RemoteResourceLoader(client: httpClient)
        let apiService = APIService(loader: remoteResourceLoader,
                                    sender: remoteResourceLoader,
                                    tokenStore: tokenStore)
        
        let tokenRefresher = RefreshTokenService(loader: refreshTokenLoader, tokenStore: tokenStore)
        let authenticatedHTTPClient = AuthenticatedURLSessionHTTPClient(decoratee: httpClient, tokenRefresher: tokenRefresher)
        let authenticatedRemoteResourceLoader = RemoteResourceLoader(client: authenticatedHTTPClient)
        
        let authenticatedAPIService = APIService(loader: authenticatedRemoteResourceLoader,
                                                 sender: authenticatedRemoteResourceLoader,
                                                 tokenStore: tokenStore)
        
        WindowGroup {
            if userLoggedIn {
                TabNavigationView(tabRouter: TabRouter(), apiService: authenticatedAPIService)
            } else {
                AuthFlowView(userLoggedIn: $userLoggedIn,
                             apiService: apiService,
                             flow: AuthFlow())
            }
        }
    }
}
