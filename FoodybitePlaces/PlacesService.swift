//
//  PlacesService.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation
import Domain
import SharedAPI

public class PlacesService {
    private let loader: ResourceLoader & DataLoader
    private struct StatusError: Error {}
    
    public init(loader: ResourceLoader & DataLoader) {
        self.loader = loader
    }
}

extension PlacesService: SearchNearbyService {
    public func searchNearby(location: Domain.Location, radius: Int) async throws -> [NearbyPlace] {
        let endpoint = SearchNearbyEndpoint(location: location, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: SearchNearbyResponse = try await loader.get(for: request)
        
        return response.results.map {
            var photo: Domain.Photo?
            
            if let firstPhoto = $0.photos?.first {
                photo = Domain.Photo(width: firstPhoto.width, height: firstPhoto.height, photoReference: firstPhoto.photoReference)
            }
            
            return NearbyPlace(
                placeID: $0.placeID,
                placeName: $0.name,
                isOpen: $0.openingHours?.openNow ?? false,
                rating: $0.rating ?? 0,
                location: Domain.Location(
                    latitude: $0.geometry.location.lat,
                    longitude: $0.geometry.location.lng
                ),
                photo: photo
            )
        }
    }
}

extension PlacesService: GetPlaceDetailsService {
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        let endpoint = GetPlaceDetailsEndpoint(placeID: placeID)
        let request = try endpoint.createURLRequest()
        let response: PlaceDetailsResponse = try await loader.get(for: request)
        
        guard response.status == .ok else {
            throw StatusError()
        }
        
        var openingHours: Domain.OpeningHoursDetails?
        
        if let hours = response.result.openingHours {
            openingHours = Domain.OpeningHoursDetails(openNow: hours.openNow, weekdayText: hours.weekdayText)
        }
        
        return PlaceDetails(
            placeID: response.result.placeID,
            phoneNumber: response.result.internationalPhoneNumber,
            name: response.result.name,
            address: response.result.formattedAddress,
            rating: response.result.rating,
            openingHoursDetails: openingHours,
            reviews: response.result.reviews.map {
                Domain.Review(
                    placeID: placeID,
                    profileImageURL: $0.profilePhotoURL,
                    profileImageData: nil,
                    authorName: $0.authorName,
                    reviewText: $0.text,
                    rating: $0.rating,
                    relativeTime: $0.relativeTimeDescription
                )
            },
            location: Domain.Location(
                latitude: response.result.geometry.location.lat,
                longitude: response.result.geometry.location.lng
            ),
            photos: response.result.photos.map {
                Domain.Photo(width: $0.width, height: $0.height, photoReference: $0.photoReference)
            }
        )
    }
}

extension PlacesService: FetchPlacePhotoService {
    public func fetchPlacePhoto(photoReference: String) async throws -> Data {
        let endpoint = GetPlacePhotoEndpoint(photoReference: photoReference)
        let request = try endpoint.createURLRequest()
        return try await loader.getData(for: request)
    }
}

extension PlacesService: AutocompletePlacesService {
    public func autocomplete(input: String, location: Domain.Location, radius: Int) async throws -> [AutocompletePrediction] {
        let endpoint = AutocompleteEndpoint(input: input, location: location, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: AutocompleteResponse = try await loader.get(for: request)
        return response.predictions.map {
            AutocompletePrediction(placePrediction: $0.description, placeID: $0.placeID)
        }
    }
}
