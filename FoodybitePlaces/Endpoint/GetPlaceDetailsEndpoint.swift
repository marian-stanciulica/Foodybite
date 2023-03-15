//
//  GetPlaceDetailsEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import SharedAPI

public struct GetPlaceDetailsEndpoint: Endpoint {
    private let placeID: String
    
    init(placeID: String) {
        self.placeID = placeID
    }
    
    public var path: String {
        "/maps/api/place/details/json"
    }
    
    public var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "place_id", value: placeID)
        ]
    }
}
