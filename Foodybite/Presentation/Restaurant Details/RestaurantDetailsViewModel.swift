//
//  RestaurantDetailsViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import UIKit
import Domain

public final class RestaurantDetailsViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    public enum Input {
        case placeIdToFetch(String)
        case fetchedPlaceDetails(PlaceDetails)
    }
    
    private let input: Input
    private let currentLocation: Location
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let getReviewsService: GetReviewsService
    private var placeDetailsReviews = [Review]()

    @Published public var error: Error?
    @Published public var placeDetails: PlaceDetails?
    
    public var rating: String {
        guard let placeDetails = placeDetails else { return "" }
        
        return String(format: "%.1f", placeDetails.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        guard let placeDetails = placeDetails else { return "" }
        
        let distance = DistanceSolver.getDistanceInKm(from: currentLocation, to: placeDetails.location)
        return "\(distance)"
    }
    
    public init(input: Input, currentLocation: Location, getPlaceDetailsService: GetPlaceDetailsService, getReviewsService: GetReviewsService) {
        self.input = input
        self.currentLocation = currentLocation
        self.getPlaceDetailsService = getPlaceDetailsService
        self.getReviewsService = getReviewsService
    }
    
    public func showMaps() {
        guard let location = placeDetails?.location else { return }
        guard let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @MainActor public func getPlaceDetails() async {
        switch input {
        case let .placeIdToFetch(placeID):
            do {
                let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
                placeDetailsReviews = placeDetails.reviews
                self.placeDetails = placeDetails
            } catch {
                self.error = .connectionFailure
            }
            
        case let .fetchedPlaceDetails(placeDetails):
            self.placeDetails = placeDetails
        }
    }
    
    @MainActor public func getPlaceReviews() async {
        if case let .placeIdToFetch(placeID) = input {
            if let reviews = try? await getReviewsService.getReviews(placeID: placeID) {
                placeDetails?.reviews = placeDetailsReviews + reviews
            }
        }
    }
}
