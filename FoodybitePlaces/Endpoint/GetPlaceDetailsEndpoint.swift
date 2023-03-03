//
//  GetPlaceDetailsEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation

public struct GetPlaceDetailsEndpoint: Endpoint {
    private let placeID: String
    
    init(placeID: String) {
        self.placeID = placeID
    }
    
    var path: String {
        "/maps/api/place/details/json"
    }
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "place_id", value: placeID)
        ]
    }
}
