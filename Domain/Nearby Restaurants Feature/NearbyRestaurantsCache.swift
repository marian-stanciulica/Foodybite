//
//  NearbyRestaurantsCache.swift
//  Domain
//
//  Created by Marian Stanciulica on 07.03.2023.
//

public protocol NearbyRestaurantsCache: Sendable {
    func save(nearbyRestaurants: [NearbyRestaurant]) async throws
}
