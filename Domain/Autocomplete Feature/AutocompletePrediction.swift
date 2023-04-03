//
//  AutocompletePrediction.swift
//  Domain
//
//  Created by Marian Stanciulica on 10.02.2023.
//

public struct AutocompletePrediction: Hashable {
    public let placePrediction: String
    public let restaurantID: String
    
    public init(placePrediction: String, restaurantID: String) {
        self.placePrediction = placePrediction
        self.restaurantID = restaurantID
    }
}
