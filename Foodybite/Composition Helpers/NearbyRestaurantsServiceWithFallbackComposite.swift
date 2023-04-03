//
//  NearbyRestaurantsServiceWithFallbackComposite.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class NearbyRestaurantsServiceWithFallbackComposite: NearbyRestaurantsService {
    private let primary: NearbyRestaurantsService
    private let secondary: NearbyRestaurantsService
    
    public init(primary: NearbyRestaurantsService, secondary: NearbyRestaurantsService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        do {
            return try await primary.searchNearby(location: location, radius: radius)
        } catch {
            return try await secondary.searchNearby(location: location, radius: radius)
        }
    }
}
