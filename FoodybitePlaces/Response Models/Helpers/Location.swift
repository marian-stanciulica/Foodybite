//
//  Location.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import Foundation

public struct Location: Decodable, Equatable {
    let lat: Double
    let lng: Double
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}
