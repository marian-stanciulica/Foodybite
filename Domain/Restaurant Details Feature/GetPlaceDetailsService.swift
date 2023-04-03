//
//  GetPlaceDetailsService.swift
//  Domain
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public protocol GetPlaceDetailsService {
    func getPlaceDetails(placeID: String) async throws -> RestaurantDetails
}
