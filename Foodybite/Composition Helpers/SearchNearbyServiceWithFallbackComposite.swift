//
//  SearchNearbyServiceWithFallbackComposite.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class SearchNearbyServiceWithFallbackComposite: SearchNearbyService {
    private let primary: SearchNearbyService
    private let secondary: SearchNearbyService
    
    public init(primary: SearchNearbyService, secondary: SearchNearbyService) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        do {
            return try await primary.searchNearby(location: location, radius: radius)
        } catch {
            return try await secondary.searchNearby(location: location, radius: radius)
        }
    }
}
