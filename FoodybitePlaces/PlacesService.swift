//
//  PlacesService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import Domain

public class PlacesService {
    private let loader: ResourceLoader & DataLoader
    private struct StatusError: Error {}
    
    public init(loader: ResourceLoader & DataLoader) {
        self.loader = loader
    }
}

extension PlacesService: NearbyRestaurantsService {
    public func searchNearby(location: Location, radius: Int) async throws -> [NearbyRestaurant] {
        let endpoint = SearchNearbyEndpoint(location: location, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: SearchNearbyResponse = try await loader.get(for: request)
        
        guard response.status == .ok else {
            throw StatusError()
        }
        
        return response.nearbyRestaurants
    }
}

extension PlacesService: RestaurantDetailsService {
    public func getRestaurantDetails(placeID: String) async throws -> RestaurantDetails {
        let endpoint = GetPlaceDetailsEndpoint(placeID: placeID)
        let request = try endpoint.createURLRequest()
        let response: PlaceDetailsResponse = try await loader.get(for: request)
        
        guard response.status == .ok else {
            throw StatusError()
        }
        
        return response.placeDetails
    }
}

extension PlacesService: RestaurantPhotoService {
    public func fetchPhoto(photoReference: String) async throws -> Data {
        let endpoint = GetPlacePhotoEndpoint(photoReference: photoReference)
        let request = try endpoint.createURLRequest()
        return try await loader.getData(for: request)
    }
}

extension PlacesService: AutocompletePlacesService {
    public func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] {
        let endpoint = AutocompleteEndpoint(input: input, location: location, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: AutocompleteResponse = try await loader.get(for: request)
        
        guard response.status == .ok else {
            throw StatusError()
        }
        
        return response.autocompletePredictions
    }
}
