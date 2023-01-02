//
//  SearchViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import FoodybitePlaces

public class SearchViewModel {
    private let service: PlaceAutocompleteService
    
    public var searchResults = [AutocompletePrediction]()
    
    public init(service: PlaceAutocompleteService) {
        self.service = service
    }
    
    public func autocomplete(input: String) async {
        do {
            searchResults = try await service.autocomplete(input: input)
        } catch {
            searchResults = []
        }
    }
}
