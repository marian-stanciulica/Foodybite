//
//  SearchNearbyEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import Domain

public enum SearchNearbyEndpoint: Endpoint {
    case searchNearby(location: Domain.Location, radius: Int)
    
    var path: String {
        "/maps/api/place/nearbysearch/json"
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .searchNearby(location, radius):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "type", value: "restaurant")
            ]
        }
    }
}
