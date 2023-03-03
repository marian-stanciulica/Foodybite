//
//  PlacesEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import Domain

public enum PlacesEndpoint: Endpoint {
    case getPlaceDetails(placeID: String)
    case getPlacePhoto(photoReference: String)
    case autocomplete(input: String, location: Domain.Location, radius: Int)
    
    var path: String {
        switch self {
        case .getPlaceDetails:
            return "/maps/api/place/details/json"
        case .getPlacePhoto:
            return "/maps/api/place/photo"
        case .autocomplete:
            return "/maps/api/place/autocomplete/json"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case let .getPlaceDetails(placeID):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "place_id", value: placeID)
            ]
        case let .getPlacePhoto(photoReference):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "photo_reference", value: photoReference),
                URLQueryItem(name: "maxwidth", value: "400"),
            ]
        case let .autocomplete(input, location, radius):
            return [
                URLQueryItem(name: "input", value: input),
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
                URLQueryItem(name: "radius", value: "\(radius)"),
                URLQueryItem(name: "type", value: "restaurant")
            ]
        }
    }
}
