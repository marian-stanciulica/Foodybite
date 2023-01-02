//
//  PlacesEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

enum PlacesEndpoint: Endpoint {
    case autocomplete(String)
    case getPlaceDetails(String)
    
    var host: String {
        "maps.googleapis.com"
    }
    
    var path: String {
        switch self {
        case .autocomplete:
            return "/maps/api/place/autocomplete/json"
        case .getPlaceDetails:
            return "/maps/api/place/details/json"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .autocomplete(input):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "input", value: input)
            ]
        case let .getPlaceDetails(placeID):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "place_id", value: placeID)
            ]
        }
    }
}
