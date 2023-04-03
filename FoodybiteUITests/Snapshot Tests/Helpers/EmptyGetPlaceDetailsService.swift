//
//  EmptyGetPlaceDetailsService.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import Domain

class EmptyGetPlaceDetailsService: GetPlaceDetailsService {
    func getPlaceDetails(placeID: String) async throws -> RestaurantDetails {
        RestaurantDetails(placeID: "",
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
