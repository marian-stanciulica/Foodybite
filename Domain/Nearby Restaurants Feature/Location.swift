//
//  Location.swift
//  Domain
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation

public struct Location: Equatable, Hashable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
