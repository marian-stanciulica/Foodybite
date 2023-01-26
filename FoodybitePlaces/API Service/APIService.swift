//
//  APIService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import DomainModels

public class APIService {
    private let loader: ResourceLoader
    
    public init(loader: ResourceLoader) {
        self.loader = loader
    }
}

extension APIService: SearchNearbyService {
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        let endpoint = PlacesEndpoint.searchNearby(location: location, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: SearchNearbyResponse = try await loader.get(for: request)
        return response.results.map {
            NearbyPlace(placeID: $0.placeID, placeName: $0.name)
        }
    }
}

extension APIService: GetPlaceDetailsService {
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        let endpoint = PlacesEndpoint.getPlaceDetails(placeID)
        let request = try endpoint.createURLRequest()
        let response: PlaceDetailsResponse = try await loader.get(for: request)
        return PlaceDetails(name: response.result.name)
    }
}
