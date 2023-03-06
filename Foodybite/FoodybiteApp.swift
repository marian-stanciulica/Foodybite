//
//  FoodybiteApp.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.05.2022.
//

import Domain
import CoreData
import SwiftUI
import FoodybiteNetworking
import FoodybitePlaces
import FoodybitePersistence

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
    
    func makeUserPreferencesStore() -> UserPreferencesLocalStore {
        return UserPreferencesLocalStore()
    }
    
    private func makeUserStore() -> UserStore {
        do {
            return try CoreDataUserStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("foodybite-store.sqlite"))
            
        } catch {
            return NullUserStore()
        }
    }
    
    lazy var localUserLoader: LocalUserLoader = {
        return LocalUserLoader(store: makeUserStore())
    }()
}

@main
struct FoodybiteApp: App {
    private let appViewModel = AppViewModel()
    @State var user: User?
    
    var body: some Scene {
        WindowGroup {
            HStack {
                if let user = user {
                    LocationCheckView { locationProvider in
                        TabNavigationView(
                            tabRouter: TabRouter(),
                            apiService: appViewModel.makeAuthenticatedApiService(),
                            placesService: appViewModel.makePlacesService(),
                            userPreferencesLoader: appViewModel.makeUserPreferencesStore(),
                            userPreferencesSaver: appViewModel.makeUserPreferencesStore(),
                            viewModel: TabNavigationViewModel(locationProvider: locationProvider),
                            user: user)
                    }
                } else {
                    AuthFlowView(flow: Flow<AuthRoute>(), apiService: appViewModel.makeApiService()) { user in
                        Task {
                            self.user = user
                            try? await appViewModel.localUserLoader.save(user: user)
                        }
                    }
                }
            }
            .task {
                self.user = try? await appViewModel.localUserLoader.load()
            }
        }
    }
}
