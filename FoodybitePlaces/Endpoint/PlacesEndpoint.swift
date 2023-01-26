//
//  PlacesEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

public enum PlacesEndpoint: Endpoint {
    case searchNearby(location: Location, radius: Int)
    case getPlaceDetails(String)
    
    var host: String {
        "maps.googleapis.com"
    }
    
    var path: String {
        switch self {
        case .searchNearby:
            return "/maps/api/place/nearbysearch/json"
        case .getPlaceDetails:
            return "/maps/api/place/details/json"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .searchNearby(location, radius):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "location", value: "\(location.lat),\(location.lng)"),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "type", value: "restaurant")
            ]
        case let .getPlaceDetails(placeID):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "place_id", value: placeID)
            ]
        }
    }
}
