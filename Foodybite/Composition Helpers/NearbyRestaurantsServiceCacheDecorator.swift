//
//  NearbyRestaurantsServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain

public final class NearbyRestaurantsServiceCacheDecorator: NearbyRestaurantsService {
    private let nearbyRestaurantsService: NearbyRestaurantsService
    private let cache: NearbyRestaurantsCache
    
    public init(nearbyRestaurantsService: NearbyRestaurantsService, cache: NearbyRestaurantsCache) {
        self.nearbyRestaurantsService = nearbyRestaurantsService
        self.cache = cache
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        let nearbyPlaces = try await nearbyRestaurantsService.searchNearby(location: location, radius: radius)
        try? await cache.save(nearbyPlaces: nearbyPlaces)
        return nearbyPlaces
    }
}