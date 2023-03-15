//
//  AutocompleteEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import Domain
import SharedAPI

struct AutocompleteEndpoint: Endpoint {
    private let input: String
    private let location: Domain.Location
    private let radius: Int
    
    init(input: String, location: Domain.Location, radius: Int) {
        self.input = input
        self.location = location
        self.radius = radius
    }
    
    var path: String {
        "/maps/api/place/autocomplete/json"
    }
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "input", value: input),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "type", value: "restaurant")
        ]
    }
}
