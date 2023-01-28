//
//  PlaceDetails.swift
//  FoodybitePlaces
//
//  Created by Marian Stanciulica on 02.01.2023.
//

public struct PlaceDetails: Equatable {
    public let phoneNumber: String
    public let name: String
    public let address: String
    public let rating: Double
    
    public init(phoneNumber: String, name: String, address: String, rating: Double) {
        self.phoneNumber = phoneNumber
        self.name = name
        self.address = address
        self.rating = rating
    }
}
