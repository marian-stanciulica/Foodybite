//
//  AutocompleteResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

struct SearchNearbyResponse: Decodable {
    let results: [SearchNearbyResult]
    let status: String
}

struct SearchNearbyResult: Decodable {
    let businessStatus: String
    let geometry: Geometry
    let icon: String
    let iconBackgroundColor: String
    let iconMaskBaseURI: String
    let name: String
    let openingHours: OpeningHours
    let photos: [Photo]
    let placeID: String
    let plusCode: PlusCode
    let priceLevel, rating: Int
    let reference, scope: String
    let types: [String]
    let userRatingsTotal: Int
    let vicinity: String

    enum CodingKeys: String, CodingKey {
        case businessStatus = "business_status"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case name
        case openingHours = "opening_hours"
        case photos
        case placeID = "place_id"
        case plusCode = "plus_code"
        case priceLevel = "price_level"
        case rating, reference, scope, types
        case userRatingsTotal = "user_ratings_total"
        case vicinity
    }
}

struct OpeningHours: Decodable {
    let openNow: Bool

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
    }
}
