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

func makeNearbyRestaurants() -> [NearbyRestaurant] {
    [
        NearbyRestaurant(
            id: "restaurant #1",
            name: "Name 1",
            isOpen: true,
            rating: 3,
            location: Location(latitude: 2, longitude: 5),
            photo: nil),
        NearbyRestaurant(
            id: "restaurant #2",
            name: "Name 2",
            isOpen: false,
            rating: 4,
            location: Location(latitude: 43, longitude: 56),
            photo: nil),
        NearbyRestaurant(
            id: "restaurant #3",
            name: "Name 3",
            isOpen: true,
            rating: 5,
            location: Location(latitude: 3, longitude: 6),
            photo: nil)
    ]
}

func makeRestaurantDetails() -> RestaurantDetails {
    RestaurantDetails(
        id: "Expected id",
        phoneNumber: "",
        name: "",
        address: "",
        rating: 0,
        openingHoursDetails: nil,
        reviews: [],
        location: Location(latitude: 0, longitude: 0),
        photos: []
    )
}

func makeReviews() -> [Review] {
    [
        Review(
            restaurantID: "restaurant #1",
            profileImageURL: nil,
            profileImageData: nil,
            authorName: "Author name #1",
            reviewText: "review text #1",
            rating: 2,
            relativeTime: "1 hour ago"
        ),
        Review(
            restaurantID: "restaurant #2",
            profileImageURL: nil,
            profileImageData: nil,
            authorName: "Author name #1",
            reviewText: "review text #2",
            rating: 3,
            relativeTime: "one year ago"
        ),
        Review(
            restaurantID: "restaurant #3",
            profileImageURL: nil,
            profileImageData: nil,
            authorName: "Author name #1",
            reviewText: "review text #3",
            rating: 4,
            relativeTime: "2 months ago"
        )
    ]
}
