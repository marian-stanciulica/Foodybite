//
//  SearchNearbyServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain

public final class SearchNearbyServiceCacheDecorator: SearchNearbyService {
    private let searchNearbyService: SearchNearbyService
    private let cache: SearchNearbyCache
    
    public init(searchNearbyService: SearchNearbyService, cache: SearchNearbyCache) {
        self.searchNearbyService = searchNearbyService
        self.cache = cache
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        let nearbyPlaces = try await searchNearbyService.searchNearby(location: location, radius: radius)
        try? await cache.save(nearbyPlaces: nearbyPlaces)
        return nearbyPlaces
    }
}
