//
//  SearchNearbyEndpoint.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import Foundation
import Domain
import SharedAPI

public struct SearchNearbyEndpoint: Endpoint {
    private let location: Domain.Location
    private let radius: Int
    
    init(location: Domain.Location, radius: Int) {
        self.location = location
        self.radius = radius
    }
    
    public var path: String {
        "/maps/api/place/nearbysearch/json"
    }
    
    public var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "type", value: "restaurant")
        ]
    }
}
