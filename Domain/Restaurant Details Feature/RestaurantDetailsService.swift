//
//  RestaurantDetailsService.swift
//  Domain
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public protocol RestaurantDetailsService {
    func getRestaurantDetails(placeID: String) async throws -> RestaurantDetails
}
