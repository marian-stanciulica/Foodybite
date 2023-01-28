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
    public func searchNearby(location: DomainModels.Location, radius: Int) async throws -> [NearbyPlace] {
        let endpoint = PlacesEndpoint.searchNearby(latitude: location.latitude, longitude: location.longitude, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: SearchNearbyResponse = try await loader.get(for: request)
        return response.results.map {
            NearbyPlace(placeID: $0.placeID, placeName: $0.name, isOpen: $0.openingHours.openNow, rating: $0.rating)
        }
    }
}

extension APIService: GetPlaceDetailsService {
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        let endpoint = PlacesEndpoint.getPlaceDetails(placeID)
        let request = try endpoint.createURLRequest()
        let response: PlaceDetailsResponse = try await loader.get(for: request)
        return PlaceDetails(
            phoneNumber: response.result.internationalPhoneNumber,
            name: response.result.name,
            address: response.result.formattedAddress,
            rating: response.result.rating,
            openingHoursDetails:
                DomainModels.OpeningHoursDetails(
                    openNow: response.result.openingHours.openNow,
                    weekdayText: response.result.openingHours.weekdayText
                ),
            reviews: response.result.reviews.map {
                DomainModels.Review(
                    profileImageURL: $0.profilePhotoURL,
                    authorName: $0.authorName,
                    reviewText: $0.text,
                    rating: $0.rating,
                    relativeTime: $0.relativeTimeDescription
                )
            },
            location: DomainModels.Location(
                latitude: response.result.geometry.location.lat,
                longitude: response.result.geometry.location.lng
            )
        )
    }
}
