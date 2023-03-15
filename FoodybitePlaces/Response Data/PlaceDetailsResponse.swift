//
//  PlaceDetailsResponse.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import Foundation

struct PlaceDetailsResponse: Decodable {
    let result: Details
    let status: PlaceDetailsStatus
}

enum PlaceDetailsStatus: String, Decodable {
    case ok = "OK"
    case zeroResults = "ZERO_RESULTS"
    case notFound = "NOT_FOUND"
    case invalidRequest = "INVALID_REQUEST"
    case overQueryLimit = "OVER_QUERY_LIMIT"
    case requestDenied = "REQUEST_DENIED"
    case unknownError = "UNKNOWN_ERROR"
}

struct Details: Decodable {
    let addressComponents: [AddressComponent]
    let businessStatus: String
    let formattedAddress: String
    let formattedPhoneNumber: String?
    let geometry: Geometry
    let icon: String
    let iconBackgroundColor: String
    let iconMaskBaseURI: String
    let internationalPhoneNumber: String?
    let name: String
    let openingHours: OpeningHoursDetails?
    let photos: [RemotePhoto]
    let placeID: String
    let plusCode: PlusCode
    let rating: Double
    let reference: String
    let reviews: [RemoteReview]
    let types: [String]
    let url: String
    let userRatingsTotal, utcOffset: Int
    let vicinity: String
    let website: String

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case businessStatus = "business_status"
        case formattedAddress = "formatted_address"
        case formattedPhoneNumber = "formatted_phone_number"
        case geometry, icon
        case iconBackgroundColor = "icon_background_color"
        case iconMaskBaseURI = "icon_mask_base_uri"
        case internationalPhoneNumber = "international_phone_number"
        case name
        case openingHours = "opening_hours"
        case photos
        case placeID = "place_id"
        case plusCode = "plus_code"
        case rating, reference, reviews, types, url
        case userRatingsTotal = "user_ratings_total"
        case utcOffset = "utc_offset"
        case vicinity, website
    }
}

struct AddressComponent: Decodable {
    let longName: String
    let shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

struct OpeningHoursDetails: Decodable {
    let openNow: Bool
    let periods: [Period]
    let weekdayText: [String]

    enum CodingKeys: String, CodingKey {
        case openNow = "open_now"
        case periods
        case weekdayText = "weekday_text"
    }
}

struct Period: Decodable {
    let close: Close?
    let periodOpen: Close

    enum CodingKeys: String, CodingKey {
        case close
        case periodOpen = "open"
    }
}

struct Close: Decodable {
    let day: Int
    let time: String
}

struct RemoteReview: Decodable {
    let authorName: String
    let authorURL: URL
    let language: String
    let profilePhotoURL: URL?
    let rating: Int
    let relativeTimeDescription, text: String
    let time: Int

    enum CodingKeys: String, CodingKey {
        case authorName = "author_name"
        case authorURL = "author_url"
        case language
        case profilePhotoURL = "profile_photo_url"
        case rating
        case relativeTimeDescription = "relative_time_description"
        case text, time
    }
}
