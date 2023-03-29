//
//  GetPlaceDetailsEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import SharedAPI

struct GetPlaceDetailsEndpoint: Endpoint {
    private let placeID: String
    
    init(placeID: String) {
        self.placeID = placeID
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
            URLQueryItem(name: "place_id", value: placeID)
        ]
    }
}
