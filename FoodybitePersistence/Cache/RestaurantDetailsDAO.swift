//
//  RestaurantDetailsDAO.swift
//  FoodybitePersistence
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class RestaurantDetailsDAO: RestaurantDetailsService, RestaurantDetailsCache {
    private let store: LocalStore

    private struct CacheMissError: Error {}

    public init(store: LocalStore) {
        self.store = store
    }
    
    public func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
        let allPlaces: [RestaurantDetails] = try await store.readAll()
        
        guard let foundPlace = allPlaces.first(where: { $0.id == restaurantID }) else {
            throw CacheMissError()
        }
        
        return foundPlace
    }
    
    public func save(restaurantDetails: RestaurantDetails) async throws {
        try await store.write(restaurantDetails)
    }
}
