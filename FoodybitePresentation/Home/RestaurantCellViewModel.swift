//
//  RestaurantCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 29.01.2023.
//

import Foundation
import Domain

public final class RestaurantCellViewModel: ObservableObject {
    private let nearbyRestaurant: NearbyRestaurant
    private let distanceInKmFromCurrentLocation: Double

    public init(nearbyRestaurant: NearbyRestaurant, distanceInKmFromCurrentLocation: Double) {
        self.nearbyRestaurant = nearbyRestaurant
        self.distanceInKmFromCurrentLocation = distanceInKmFromCurrentLocation
    }

    public var isOpen: Bool {
        nearbyRestaurant.isOpen
    }

    public var restaurantName: String {
        nearbyRestaurant.name
    }

    public var rating: String {
        String(format: "%.1f", nearbyRestaurant.rating)
    }

    public var distance: String {
        return "\(distanceInKmFromCurrentLocation)"
    }
}
