//
//  SearchNearbyService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import DomainModels

public protocol SearchNearbyService {
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace]
}
