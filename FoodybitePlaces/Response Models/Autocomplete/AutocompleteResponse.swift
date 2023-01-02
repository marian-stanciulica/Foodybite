//
//  AutocompleteResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

struct AutocompleteResponse: Decodable {
    let predictions: [AutocompletePrediction]
}
