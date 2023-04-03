//
//  RestaurantDetails.swift
//  Domain
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct RestaurantDetails: Equatable, Hashable {
    public let restaurantID: String
    public let phoneNumber: String?
    public let name: String
    public let address: String
    public let rating: Double
    public let openingHoursDetails: OpeningHoursDetails?
    public var reviews: [Review]
    public let location: Location
    public let photos: [Photo]
    
    public init(restaurantID: String, phoneNumber: String?, name: String, address: String, rating: Double, openingHoursDetails: OpeningHoursDetails?, reviews: [Review], location: Location, photos: [Photo]) {
        self.restaurantID = restaurantID
        self.phoneNumber = phoneNumber
        self.name = name
        self.address = address
        self.rating = rating
        self.openingHoursDetails = openingHoursDetails
        self.reviews = reviews
        self.location = location
        self.photos = photos
    }
    
    public static func ==(lhs: RestaurantDetails, rhs: RestaurantDetails) -> Bool {
        lhs.restaurantID == rhs.restaurantID &&
        lhs.phoneNumber == rhs.phoneNumber &&
        lhs.name == rhs.name &&
        lhs.address == rhs.address &&
        lhs.location == rhs.location
    }
}
