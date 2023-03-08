//
//  GetPlaceDetailsServiceCacheDecorator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class GetPlaceDetailsServiceCacheDecorator: GetPlaceDetailsService {
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let cache: PlaceDetailsCache
    
    public init(getPlaceDetailsService: GetPlaceDetailsService, cache: PlaceDetailsCache) {
        self.getPlaceDetailsService = getPlaceDetailsService
        self.cache = cache
    }
    
   public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
        try await cache.save(placeDetails: placeDetails)
        return placeDetails
    }
}
