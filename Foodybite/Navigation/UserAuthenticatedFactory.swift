//
//  UserAuthenticatedFactory.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

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
    
    lazy var searchNearbyDAO = SearchNearbyDAO(store: userStore,
                                               getDistanceInKm: DistanceSolver.getDistanceInKm)
    
    lazy var placeDetailsDAO = GetPlaceDetailsDAO(store: userStore)
}
