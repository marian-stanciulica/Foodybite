//
//  ProfileRoute.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Domain

public enum ProfileRoute: Hashable {
    case settings
    case changePassword
    case editProfile
    case placeDetails(RestaurantDetails)
    case addReview(String)
}
