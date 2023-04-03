//
//  SearchNearbyServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain

public final class SearchNearbyServiceCacheDecorator: NearbyRestaurantsService {
    private let searchNearbyService: NearbyRestaurantsService
    private let cache: NearbyRestaurantsCache
    
    public init(searchNearbyService: NearbyRestaurantsService, cache: NearbyRestaurantsCache) {
        self.searchNearbyService = searchNearbyService
        self.cache = cache
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        let nearbyPlaces = try await searchNearbyService.searchNearby(location: location, radius: radius)
        try? await cache.save(nearbyPlaces: nearbyPlaces)
        return nearbyPlaces
    }
}
