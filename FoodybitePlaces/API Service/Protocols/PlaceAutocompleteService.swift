//
//  PlaceAutocompleteService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public protocol PlaceAutocompleteService {
    func autocomplete(input: String) async throws -> [AutocompletePrediction]
}
