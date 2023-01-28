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
    
    public init(placeID: String, placeName: String, isOpen: Bool) {
        self.placeID = placeID
        self.placeName = placeName
        self.isOpen = isOpen
    }
}
