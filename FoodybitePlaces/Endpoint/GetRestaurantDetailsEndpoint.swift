//
//  GetPlaceDetailsEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation

struct GetRestaurantDetailsEndpoint: Endpoint {
    private let restaurantID: String

    init(restaurantID: String) {
        self.restaurantID = restaurantID
    }

    var path: String {
        "/maps/api/place/details/json"
    }

    var method: RequestMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "place_id", value: restaurantID)
        ]
    }
}
