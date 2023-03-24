//
//  UserAuthenticatedFactory.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import CoreData
import SharedAPI
import FoodybitePlaces
import FoodybiteNetworking
import FoodybitePersistence

final class UserAuthenticatedFactory {
    let authenticatedApiService: APIService = {
        let httpClient = URLSessionHTTPClient()
        let refreshTokenLoader = RemoteStore(client: httpClient)
        let tokenStore = KeychainTokenStore()
        
        let tokenRefresher = RefreshTokenService(
            loader: refreshTokenLoader,
            tokenStore: tokenStore
        )
        let authenticatedHTTPClient = AuthenticatedURLSessionHTTPClient(
            decoratee: httpClient,
            tokenRefresher: tokenRefresher
        )
        let authenticatedRemoteResourceLoader = RemoteStore(client: authenticatedHTTPClient)
        
        return APIService(loader: authenticatedRemoteResourceLoader,
                          sender: authenticatedRemoteResourceLoader,
                          tokenStore: tokenStore)
    }()
    
    let placesService: PlacesService = {
        let httpClient = URLSessionHTTPClient()
        let loader = RemoteLoader(client: httpClient)
        return PlacesService(loader: loader)
    }()
    
    let userPreferencesStore = UserPreferencesLocalStore()
    
    let searchNearbyDAO = SearchNearbyDAO(store: RootFactory.localStore,
                                          getDistanceInKm: DistanceSolver.getDistanceInKm)
    
    let placeDetailsDAO = GetPlaceDetailsDAO(store: RootFactory.localStore)
    
    let reviewDAO = ReviewDAO(store: RootFactory.localStore)
    
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
            cache: reviewDAO
        ),
        secondary: reviewDAO
    )
}
