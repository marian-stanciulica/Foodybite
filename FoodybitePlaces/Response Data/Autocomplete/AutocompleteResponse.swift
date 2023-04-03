//
//  AutocompleteResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import Foundation
import Domain

struct AutocompleteResponse: Decodable {
    let predictions: [Prediction]
    let status: AutocompleteStatus
    
    var autocompletePredictions: [AutocompletePrediction] {
        predictions.map {
            AutocompletePrediction(placePrediction: $0.description, restaurantID: $0.placeID)
        }
    }
    
}
