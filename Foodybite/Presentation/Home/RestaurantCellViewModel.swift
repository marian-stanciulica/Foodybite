//
//  RestaurantCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import DomainModels

public final class RestaurantCellViewModel {
    private let nearbyPlace: NearbyPlace
    
    public init(nearbyPlace: NearbyPlace) {
        self.nearbyPlace = nearbyPlace
    }
    
    public var isOpen: Bool {
        nearbyPlace.isOpen
    }
    
    public var placeName: String {
        nearbyPlace.placeName
    }
    
    public var rating: String {
        String(format: "%.1f", nearbyPlace.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        let source = Location(latitude: 44.437367393150396, longitude: 26.02757207676153)
        let distance = DistanceSolver.getDistanceInKm(from: source, to: nearbyPlace.location)
        return "\(distance)"
    }
}
