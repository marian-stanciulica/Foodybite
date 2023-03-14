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

final class UserAuthenticatedFactory {
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
    
    let searchNearbyDAO = SearchNearbyDAO(store: RootFactory.localStore,
                                          getDistanceInKm: DistanceSolver.getDistanceInKm)
    
    let placeDetailsDAO = GetPlaceDetailsDAO(store: RootFactory.localStore)
    
    lazy var getPlaceDetailsWithFallbackComposite = GetPlaceDetailsWithFallbackComposite(
        primary: GetPlaceDetailsServiceCacheDecorator(
            getPlaceDetailsService: placesService,
            cache: placeDetailsDAO
        ),
        secondary: placeDetailsDAO
    )
    
    lazy var getReviewsWithFallbackComposite = GetReviewsServiceWithFallbackComposite(
        primary: GetReviewsServiceCacheDecorator(
            getReviewsService: authenticatedApiService,
            cache: RootFactory.localStore
        ),
        secondary: RootFactory.localStore
    )
}
