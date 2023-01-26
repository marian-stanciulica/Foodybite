//
//  NearbyPlace.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct NearbyPlace: Equatable {
    public let placeID: String
    public let placeName: String
    
    public init(placeID: String, placeName: String) {
        self.placeID = placeID
        self.placeName = placeName
    }
}
