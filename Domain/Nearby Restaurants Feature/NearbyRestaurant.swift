//
//  NearbyRestaurant.swift
//  Domain
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct NearbyRestaurant: Equatable {
    public let restaurantID: String
    public let placeName: String
    public let isOpen: Bool
    public let rating: Double
    public let location: Location
    public let photo: Photo?
    
    public init(restaurantID: String, placeName: String, isOpen: Bool, rating: Double, location: Location, photo: Photo?) {
        self.restaurantID = restaurantID
        self.placeName = placeName
        self.isOpen = isOpen
        self.rating = rating
        self.location = location
        self.photo = photo
    }
    
    public static func ==(lhs: NearbyRestaurant, rhs: NearbyRestaurant) -> Bool {
        lhs.restaurantID == rhs.restaurantID &&
        lhs.placeName == rhs.placeName &&
        lhs.location == rhs.location &&
        lhs.photo == rhs.photo
    }
}
