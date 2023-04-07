//
//  AutocompletePrediction.swift
//  Domain
//
//  Created by Marian Stanciulica on 10.02.2023.
//

public struct AutocompletePrediction: Hashable {
    public let restaurantPrediction: String
    public let restaurantID: String

    public init(restaurantPrediction: String, restaurantID: String) {
        self.restaurantPrediction = restaurantPrediction
        self.restaurantID = restaurantID
    }
}
