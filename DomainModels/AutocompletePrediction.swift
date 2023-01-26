//
//  AutocompletePrediction.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct AutocompletePrediction: Equatable {
    let placeID: String
    let placeName: String
    
    public init(placeID: String, placeName: String) {
        self.placeID = placeID
        self.placeName = placeName
    }
}
