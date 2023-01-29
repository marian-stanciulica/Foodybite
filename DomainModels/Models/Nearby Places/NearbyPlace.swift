//
//  NearbyPlace.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct NearbyPlace: Equatable {
    public let placeID: String
    public let placeName: String
    public let isOpen: Bool
    public let rating: Double
    public let location: Location
    
    public init(placeID: String, placeName: String, isOpen: Bool, rating: Double, location: Location) {
        self.placeID = placeID
        self.placeName = placeName
        self.isOpen = isOpen
        self.rating = rating
        self.location = location
    }
}
