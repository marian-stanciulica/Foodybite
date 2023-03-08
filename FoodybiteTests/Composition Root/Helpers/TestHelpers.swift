//
//  TestHelpers.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Foundation
import Domain

func anyLocation() -> Location {
    Location(latitude: 0, longitude: 0)
}

func anyError() -> NSError {
    NSError(domain: "any error", code: 1)
}

func makeNearbyPlaces() -> [NearbyPlace] {
    [
        NearbyPlace(
            placeID: "place #1",
            placeName: "Place name 1",
            isOpen: true,
            rating: 3,
            location: Location(latitude: 2, longitude: 5),
            photo: nil),
        NearbyPlace(
            placeID: "place #2",
            placeName: "Place name 2",
            isOpen: false,
            rating: 4,
            location: Location(latitude: 43, longitude: 56),
            photo: nil),
        NearbyPlace(
            placeID: "place #3",
            placeName: "Place name 3",
            isOpen: true,
            rating: 5,
            location: Location(latitude: 3, longitude: 6),
            photo: nil)
    ]
}
