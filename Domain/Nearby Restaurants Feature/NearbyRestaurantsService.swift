//
//  SearchNearbyService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public protocol NearbyRestaurantsService {
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant]
}
