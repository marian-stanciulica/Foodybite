//
//  SearchNearbyResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Domain

struct SearchNearbyResponse: Decodable {
    let results: [SearchNearbyResult]
    let status: SearchNearbyStatus

    var nearbyRestaurants: [NearbyRestaurant] {
        results.map {
            NearbyRestaurant(
                id: $0.placeID,
                name: $0.name,
                isOpen: $0.openingHours?.openNow ?? false,
                rating: $0.rating ?? 0,
                location: Location(
                    latitude: $0.geometry.location.lat,
                    longitude: $0.geometry.location.lng
                ),
                photo: $0.photos?.first?.model
            )
        }
    }

}
