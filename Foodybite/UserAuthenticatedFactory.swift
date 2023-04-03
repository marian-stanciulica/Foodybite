//
//  UserAuthenticatedFactory.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import CoreData
import API_Infra
import FoodybitePlaces
import FoodybiteNetworking
import FoodybitePersistence
import FoodybiteLocation

final class UserAuthenticatedFactory {
    let authenticatedApiService: APIService = {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
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
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let loader = RemoteLoader(client: httpClient)
        return PlacesService(loader: loader)
    }()
    
    let userPreferencesStore = UserPreferencesLocalStore()
    
    private let nearbyRestaurantsDAO = NearbyRestaurantsDAO(store: RootFactory.localStore,
                                                            getDistanceInKm: DistanceSolver.getDistanceInKm)
    
    private let restaurantDetailsDAO = RestaurantDetailsDAO(store: RootFactory.localStore)
    
    private let reviewDAO = ReviewDAO(store: RootFactory.localStore)
    
    lazy var searchNearbyWithFallbackComposite = NearbyRestaurantsServiceWithFallbackComposite(
        primary: NearbyRestaurantsServiceCacheDecorator(
            nearbyRestaurantsService: placesService,
            cache: nearbyRestaurantsDAO
        ),
        secondary: nearbyRestaurantsDAO
    )
    
    lazy var getPlaceDetailsWithFallbackComposite = RestaurantDetailsServiceWithFallbackComposite(
        primary: RestaurantDetailsServiceCacheDecorator(
            restaurantDetailsService: placesService,
            cache: restaurantDetailsDAO
        ),
        secondary: restaurantDetailsDAO
    )
    
    lazy var getReviewsWithFallbackComposite = GetReviewsServiceWithFallbackComposite(
        primary: GetReviewsServiceCacheDecorator(
            getReviewsService: authenticatedApiService,
            cache: reviewDAO
        ),
        secondary: reviewDAO
    )
}
