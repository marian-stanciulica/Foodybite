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
        let endpoint = PlacesEndpoint.searchNearby(location: location, radius: radius)
        let request = try endpoint.createURLRequest()
        let response: SearchNearbyResponse = try await loader.get(for: request)
        
        return response.results.map {
            var photo: DomainModels.Photo?
            
            if let firstPhoto = $0.photos?.first {
                photo = DomainModels.Photo(width: firstPhoto.width, height: firstPhoto.height, photoReference: firstPhoto.photoReference)
            }
            
            return NearbyPlace(
                placeID: $0.placeID,
                placeName: $0.name,
                isOpen: $0.openingHours?.openNow ?? false,
                rating: $0.rating ?? 0,
                location: DomainModels.Location(
                    latitude: $0.geometry.location.lat,
                    longitude: $0.geometry.location.lng
                ),
                photo: photo
            )
        }
    }
}

extension APIService: GetPlaceDetailsService {
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        let endpoint = PlacesEndpoint.getPlaceDetails(placeID: placeID)
        let request = try endpoint.createURLRequest()
        let response: PlaceDetailsResponse = try await loader.get(for: request)
        
        var openingHours: DomainModels.OpeningHoursDetails?
        
        if let hours = response.result.openingHours {
            openingHours = DomainModels.OpeningHoursDetails(openNow: hours.openNow, weekdayText: hours.weekdayText)
        }
        
        return PlaceDetails(
            phoneNumber: response.result.internationalPhoneNumber,
            name: response.result.name,
            address: response.result.formattedAddress,
            rating: response.result.rating,
            openingHoursDetails: openingHours,
            reviews: response.result.reviews.map {
                DomainModels.Review(
                    profileImageURL: $0.profilePhotoURL,
                    profileImageData: nil,
                    authorName: $0.authorName,
                    reviewText: $0.text,
                    rating: $0.rating,
                    relativeTime: $0.relativeTimeDescription
                )
            },
            location: DomainModels.Location(
                latitude: response.result.geometry.location.lat,
                longitude: response.result.geometry.location.lng
            ),
            photos: response.result.photos.map {
                DomainModels.Photo(width: $0.width, height: $0.height, photoReference: $0.photoReference)
            }
        )
    }
}

extension APIService: FetchPlacePhotoService {
    public func fetchPlacePhoto(photoReference: String) async throws -> Data {
        let endpoint = PlacesEndpoint.getPlacePhoto(photoReference: photoReference)
        let request = try endpoint.createURLRequest()
        return try await loader.getData(for: request)
    }
}
