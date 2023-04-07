//
//  RestaurantDetailsServiceWithFallbackComposite.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

public final class RestaurantDetailsServiceWithFallbackComposite: RestaurantDetailsService {
    private let primary: RestaurantDetailsService
    private let secondary: RestaurantDetailsService

    public init(primary: RestaurantDetailsService, secondary: RestaurantDetailsService) {
        self.primary = primary
        self.secondary = secondary
    }

    public func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
        do {
            return try await primary.getRestaurantDetails(restaurantID: restaurantID)
        } catch {
            return try await secondary.getRestaurantDetails(restaurantID: restaurantID)
        }
    }
}
