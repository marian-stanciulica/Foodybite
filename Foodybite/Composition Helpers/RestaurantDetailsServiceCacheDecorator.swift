//
//  RestaurantDetailsServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class RestaurantDetailsServiceCacheDecorator: RestaurantDetailsService {
    private let restaurantDetailsService: RestaurantDetailsService
    private let cache: RestaurantDetailsCache
    
    public init(restaurantDetailsService: RestaurantDetailsService, cache: RestaurantDetailsCache) {
        self.restaurantDetailsService = restaurantDetailsService
        self.cache = cache
    }
    
    public func getRestaurantDetails(placeID: String) async throws -> RestaurantDetails {
        let placeDetails = try await restaurantDetailsService.getRestaurantDetails(placeID: placeID)
        try? await cache.save(placeDetails: placeDetails)
        return placeDetails
    }
}
