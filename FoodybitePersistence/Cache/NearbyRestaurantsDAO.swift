//
//  NearbyRestaurantsDAO.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain

public final class NearbyRestaurantsDAO: NearbyRestaurantsService, NearbyRestaurantsCache {
    private let store: LocalStore
    private let getDistanceInKm: (Location, Location) -> Double
    
    public init(store: LocalStore, getDistanceInKm: @escaping (Location, Location) -> Double) {
        self.store = store
        self.getDistanceInKm = getDistanceInKm
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        try await store.readAll()
            .filter {
                let distance = getDistanceInKm(location, $0.location)
                return Int(distance) < radius
            }
    }
    
    public func save(nearbyPlaces: [NearbyRestaurant]) async throws {
        try await store.writeAll(nearbyPlaces)
    }
}
