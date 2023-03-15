//
//  Details.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 15.03.2023.
//

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
    let openingHours: RemoteOpeningHoursDetails?
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
