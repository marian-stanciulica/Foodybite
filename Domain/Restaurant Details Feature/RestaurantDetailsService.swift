//
//  RestaurantDetailsService.swift
//  Domain
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public protocol RestaurantDetailsService: Sendable {
    func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails
}
