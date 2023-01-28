//
//  SearchNearbyService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public protocol SearchNearbyService {
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace]
}
