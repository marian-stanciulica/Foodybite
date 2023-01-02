//
//  PlacesEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

enum PlacesEndpoint: Endpoint {
    case autocomplete
    
    var host: String {
        "https://maps.googleapis.com/maps/api/place"
    }
    
    var path: String {
        "/autocomplete/json"
    }

    var method: RequestMethod {
        .get
    }
    
    var body: Codable? {
        nil
    }
}
