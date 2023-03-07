//
//  SearchNearbyDAO.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Domain

public final class SearchNearbyDAO: SearchNearbyService {
    private let store: LocalStoreReader & LocalStoreWriter
    private let getDistanceInKm: (Location, Location) -> Double
    
    public init(store: LocalStoreReader & LocalStoreWriter, getDistanceInKm: @escaping (Location, Location) -> Double) {
        self.store = store
        self.getDistanceInKm = getDistanceInKm
    }
    
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        try await store.readAll()
            .filter {
                let distance = getDistanceInKm(location, $0.location)
                return Int(distance) < radius
            }
    }
    
    public func save(nearbyPlaces: [NearbyPlace]) async throws {
        try await store.writeAll(nearbyPlaces)
    }
}
