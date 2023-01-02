//
//  APIService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

public class APIService {
    private let loader: ResourceLoader
    
    public init(loader: ResourceLoader) {
        self.loader = loader
    }
}

extension APIService: PlaceAutocompleteService {
    public func autocomplete(input: String) async throws -> [AutocompletePrediction] {
        let endpoint = PlacesEndpoint.autocomplete(input)
        let request = try endpoint.createURLRequest()
        let response: AutocompleteResponse = try await loader.get(for: request)
        return response.predictions
    }
}
