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

func makePhotoData() -> Data {
    UIImage.make(withColor: .blue).pngData()!
}

func makeReviewText() -> String {
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut sit amet dapibus justo, eu cursus nulla. Nulla viverra mollis ante et rutrum. Mauris lorem ante, congue eget malesuada quis, hendrerit vel elit. Suspendisse potenti. Phasellus molestie vehicula blandit. Fusce sit amet egestas augue. Integer quis lacinia massa. Aliquam hendrerit arcu eget leo congue maximus. Etiam interdum eget mi at consectetur."
}
