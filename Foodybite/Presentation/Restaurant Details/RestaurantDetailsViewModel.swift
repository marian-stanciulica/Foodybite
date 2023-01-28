//
//  RestaurantDetailsViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import DomainModels

public final class RestaurantDetailsViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let placeID: String
    private let getPlaceDetailsService: GetPlaceDetailsService
    @Published public var error: Error?
    @Published public var placeDetails: PlaceDetails?
    
    public var rating: String {
        guard let placeDetails = placeDetails else { return "" }
        
        return String(format: "%.1f", placeDetails.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        guard let placeDetails = placeDetails else { return "" }

        let source = Location(latitude: -33.8670522, longitude: 151.1957362)
        let distance = DistanceSolver.getDistanceInKm(from: source, to: placeDetails.location)
        return "\(distance)"
    }
    
    public init(placeID: String, getPlaceDetailsService: GetPlaceDetailsService) {
        self.placeID = placeID
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    @MainActor public func getPlaceDetails() async {
        do {
            error = nil
            placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
        } catch {
            placeDetails = nil
            self.error = .connectionFailure
        }
    }
}
