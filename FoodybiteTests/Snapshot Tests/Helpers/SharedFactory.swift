//
//  SharedFactory.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import Domain

func makePlaceDetails() -> PlaceDetails {
    PlaceDetails(placeID: "",
                 phoneNumber: nil,
                 name: "Place name",
                 address: "Place address",
                 rating: 4,
                 openingHoursDetails: nil,
                 reviews: [],
                 location: Location(latitude: 0, longitude: 0),
                 photos: [])
}
