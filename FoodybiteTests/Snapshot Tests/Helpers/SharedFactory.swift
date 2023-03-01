//
//  SharedFactory.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import Foundation
import UIKit
import Domain

func makePlaceDetails() -> PlaceDetails {
    PlaceDetails(placeID: "place #1",
                 phoneNumber: "0764 456 321",
                 name: "Place name",
                 address: "Place address",
                 rating: 4,
                 openingHoursDetails: OpeningHoursDetails(openNow: true, weekdayText: ["Mon: 10:00 - 17:00"]),
                 reviews: [
                    Review(placeID: "place #1", profileImageURL: nil, profileImageData: makePhotoData(), authorName: "Author", reviewText: makeReviewText(), rating: 4, relativeTime: "an hour ago")
                 ],
                 location: Location(latitude: 3.4, longitude: 6.5),
                 photos: [
                    Photo(width: 100, height: 100, photoReference: "reference"),
                    Photo(width: 100, height: 100, photoReference: "reference"),
                    Photo(width: 100, height: 100, photoReference: "reference")
                 ])
}

func makePhotoData() -> Data {
    UIImage.make(withColor: .blue).pngData()!
}

func makeReviewText() -> String {
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sit amet dapibus justo, eu cursus nulla. Nulla viverra mollis ante et rutrum. Mauris lorem ante, congue eget malesuada quis, hendrerit vel elit. Suspendisse potenti. Phasellus molestie vehicula blandit. Fusce sit amet egestas augue. Integer quis lacinia massa. Aliquam hendrerit arcu eget leo congue maximus. Etiam interdum eget mi at consectetur."
}
