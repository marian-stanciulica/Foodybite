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
    private let distanceInKmFromCurrentLocation: Double
    
    public init(nearbyPlace: NearbyPlace, distanceInKmFromCurrentLocation: Double) {
        self.nearbyPlace = nearbyPlace
        self.distanceInKmFromCurrentLocation = distanceInKmFromCurrentLocation
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
    
    public var distance: String {
        return "\(distanceInKmFromCurrentLocation)"
    }
}
