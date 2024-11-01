//
//  PlacesService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import Domain

public final class PlacesService {
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

        guard response.status == .okStatus else {
            throw StatusError()
        }

        return response.nearbyRestaurants
    }
}

extension PlacesService: RestaurantDetailsService {
    public func getRestaurantDetails(restaurantID: String) async throws -> RestaurantDetails {
        let endpoint = GetRestaurantDetailsEndpoint(restaurantID: restaurantID)
        let request = try endpoint.createURLRequest()
        let response: PlaceDetailsResponse = try await loader.get(for: request)

        guard response.status == .okStatus else {
            throw StatusError()
        }

        return response.restaurantDetails
    }
}

extension PlacesService: RestaurantPhotoService {
    public func fetchPhoto(photoReference: String) async throws -> Data {
        let endpoint = GetPlacePhotoEndpoint(photoReference: photoReference)
        let request = try endpoint.createURLRequest()
        return try await loader.getData(for: request)
    }
}

extension PlacesService: AutocompleteRestaurantsService {
    public func autocomplete(input: String, location: Location, radius: Int) async throws -> [AutocompletePrediction] {
        let endpoint = AutocompleteEndpoint(input: input, location: location, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: AutocompleteResponse = try await loader.get(for: request)

        guard response.status == .okStatus else {
            throw StatusError()
        }

        return response.autocompletePredictions
    }
}
