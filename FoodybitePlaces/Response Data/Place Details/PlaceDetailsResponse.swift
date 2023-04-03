//
//  PlaceDetailsResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Domain

struct PlaceDetailsResponse: Decodable {
    let result: Details
    let status: PlaceDetailsStatus
    
    var placeDetails: RestaurantDetails {
        RestaurantDetails(
            placeID: result.placeID,
            phoneNumber: result.internationalPhoneNumber,
            name: result.name,
            address: result.formattedAddress,
            rating: result.rating,
            openingHoursDetails: result.openingHours?.model,
            reviews: result.reviews.map {
                Review(
                    placeID: result.placeID,
                    profileImageURL: $0.profilePhotoURL,
                    profileImageData: nil,
                    authorName: $0.authorName,
                    reviewText: $0.text,
                    rating: $0.rating,
                    relativeTime: $0.relativeTimeDescription
                )
            },
            location: Location(
                latitude: result.geometry.location.lat,
                longitude: result.geometry.location.lng
            ),
            photos: result.photos.map { $0.model }
        )
    }
    
}
