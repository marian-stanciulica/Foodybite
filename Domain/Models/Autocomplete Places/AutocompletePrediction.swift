//
//  AutocompletePrediction.swift
//  Domain
//
//  Created by Marian Stanciulica on 10.02.2023.
//

public struct AutocompletePrediction: Equatable {
    public let placePrediction: String
    public let placeID: String
    
    public init(placePrediction: String, placeID: String) {
        self.placePrediction = placePrediction
        self.placeID = placeID
    }
}
