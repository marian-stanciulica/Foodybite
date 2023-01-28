//
//  Location.swift
//  DomainModels
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation

public struct Location: Equatable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
