//
//  AutocompleteRestaurantsService.swift
//  Domain
//
//  Created by Marian Stanciulica on 09.02.2023.
//

public protocol AutocompleteRestaurantsService {
    func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction]
}
