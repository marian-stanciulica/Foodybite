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
    
    lazy var userStore: LocalStoreReader & LocalStoreWriter = {
        do {
            return try CoreDataLocalStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("foodybite-store.sqlite"))
            
        } catch {
            return NullUserStore()
        }
    }()
}

@main
struct FoodybiteApp: App {
    private let appViewModel = AppViewModel()
    @State var user: User?
    @ObservedObject var authflow = Flow<AuthRoute>()

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
                            user: user,
                            searchNearbyDAO: SearchNearbyDAO(
                                store: appViewModel.userStore,
                                getDistanceInKm: DistanceSolver.getDistanceInKm
                            )
                        )
                    }
                } else {
                    makeAuthFlowView(loginService: appViewModel.makeApiService(),
                                     signUpService: appViewModel.makeApiService()) { user in
                        Task {
                            self.user = user
                            try? await appViewModel.userStore.write(user)
                        }
                    }
                }
            }
            .task {
                self.user = try? await appViewModel.userStore.read()
            }
        }
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
