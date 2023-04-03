//
//  GetPlaceDetailsServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class GetPlaceDetailsServiceCacheDecorator: RestaurantDetailsService {
    private let getPlaceDetailsService: RestaurantDetailsService
    private let cache: RestaurantDetailsCache
    
    public init(getPlaceDetailsService: RestaurantDetailsService, cache: RestaurantDetailsCache) {
        self.getPlaceDetailsService = getPlaceDetailsService
        self.cache = cache
    }
    
    public func getRestaurantDetails(placeID: String) async throws -> RestaurantDetails {
        let placeDetails = try await getPlaceDetailsService.getRestaurantDetails(placeID: placeID)
        try? await cache.save(placeDetails: placeDetails)
        return placeDetails
    }
}
