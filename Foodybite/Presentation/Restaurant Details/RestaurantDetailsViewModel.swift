//
//  RestaurantDetailsViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import DomainModels

public final class RestaurantDetailsViewModel {
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    public var error: Error?
    public var placeDetails: PlaceDetails?
    
    public init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    public func getPlaceDetails() async {
        do {
            error = nil
            placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
        } catch {
            self.error = .connectionFailure
        }
    }
}
