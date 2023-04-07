//
//  RestaurantDetailsServiceStub.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Domain

final class RestaurantDetailsServiceStub: RestaurantDetailsService {
    private(set) var capturedValues = [String]()
    var stub: Result<RestaurantDetails, Error>?

    func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
        capturedValues.append(restaurantID)

        if let stub = stub {
            return try stub.get()
        }

        return RestaurantDetails(id: "",
                            phoneNumber: nil,
                            name: "",
                            address: "",
                            rating: 0,
                            openingHoursDetails: nil,
                            reviews: [],
                            location: Location(latitude: 0, longitude: 0),
                            photos: [])
    }
}
