//
//  NearbyRestaurantsServiceStub.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

final class NearbyRestaurantsServiceStub: NearbyRestaurantsService {
    private(set) var capturedValues = [(location: Location, radius: Int)]()
    var stub: Result<[NearbyRestaurant], Error>?

    func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        capturedValues.append((location, radius))

        if let stub = stub {
            return try stub.get()
        }

        return []
    }
}
