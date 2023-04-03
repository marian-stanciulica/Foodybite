//
//  SearchNearbyCache.swift
//  Domain
//
//  Created by Marian Stanciulica on 07.03.2023.
//

public protocol SearchNearbyCache {
    func save(nearbyPlaces: [NearbyRestaurant]) async throws
}
