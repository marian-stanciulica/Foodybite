//
//  RestaurantDetailsCache.swift
//  Domain
//
//  Created by Marian Stanciulica on 08.03.2023.
//

public protocol RestaurantDetailsCache {
    func save(restaurantDetails: RestaurantDetails) async throws
}
