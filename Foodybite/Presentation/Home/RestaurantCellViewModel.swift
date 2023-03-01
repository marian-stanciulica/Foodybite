//
//  RestaurantCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import Foundation
import Domain

public final class RestaurantCellViewModel: ObservableObject {
    private let nearbyPlace: NearbyPlace
    private let currentLocation: Location
    
    @Published public var imageData: Data?
    
    public init(nearbyPlace: NearbyPlace, currentLocation: Location) {
        self.nearbyPlace = nearbyPlace
        self.currentLocation = currentLocation
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
        let distance = DistanceSolver.getDistanceInKm(from: currentLocation, to: nearbyPlace.location)
        return "\(distance)"
    }
}
