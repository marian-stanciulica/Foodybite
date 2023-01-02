//
//  PlacesEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

enum PlacesEndpoint: Endpoint {
    case autocomplete(String)
    
    var host: String {
        "https://maps.googleapis.com/maps/api/place"
    }
    
    var path: String {
        switch self {
        case .autocomplete:
            return "/autocomplete/json"
        }
    }
    
    var method: RequestMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .autocomplete(let input):
            return [
                URLQueryItem(name: "key", value: apiKey),
                URLQueryItem(name: "input", value: input)
            ]
        }
    }
}
