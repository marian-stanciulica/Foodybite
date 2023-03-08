//
//  UserAuthenticatedFactory.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import CoreData
import FoodybitePlaces
import FoodybiteNetworking
import FoodybitePersistence

final class UserAuthenticatedFactory: RootFactory {
    let authenticatedApiService: FoodybiteNetworking.APIService = {
        let httpClient = FoodybiteNetworking.URLSessionHTTPClient()
        let refreshTokenLoader = RemoteResourceLoader(client: httpClient)
        let tokenStore = KeychainTokenStore()
                
        let tokenRefresher = RefreshTokenService(loader: refreshTokenLoader, tokenStore: tokenStore)
        let authenticatedHTTPClient = AuthenticatedURLSessionHTTPClient(decoratee: httpClient, tokenRefresher: tokenRefresher)
        let authenticatedRemoteResourceLoader = RemoteResourceLoader(client: authenticatedHTTPClient)
        
        return APIService(loader: authenticatedRemoteResourceLoader,
                          sender: authenticatedRemoteResourceLoader,
                          tokenStore: tokenStore)
    }()
    
    let placesService: FoodybitePlaces.APIService = {
        let httpClient = FoodybitePlaces.URLSessionHTTPClient()
        let loader = FoodybitePlaces.RemoteResourceLoader(client: httpClient)
        return FoodybitePlaces.APIService(loader: loader)
    }()
    
    let userPreferencesStore = UserPreferencesLocalStore()
    
    let searchNearbyDAO: SearchNearbyDAO = {
        let userStore: LocalStoreWriter & LocalStoreReader
        
        do {
            userStore = try CoreDataLocalStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("foodybite-store.sqlite"))
            
        } catch {
            userStore = NullUserStore()
        }
        
        return SearchNearbyDAO(store: userStore,
                               getDistanceInKm: DistanceSolver.getDistanceInKm)
    }()
    
    lazy var placeDetailsDAO = GetPlaceDetailsDAO(store: userStore)
}
