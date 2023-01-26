//
//  PlaceAutocompleteService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import DomainModels

public protocol PlaceAutocompleteService {
    func autocomplete(input: String) async throws -> [AutocompletePrediction]
}
