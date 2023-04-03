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
    public enum GetPlaceDetailsError: String, Swift.Error {
        case serverError = "Server connection failed. Please try again!"
    }
    
    public enum Input {
        case placeIdToFetch(String)
        case fetchedPlaceDetails(RestaurantDetails)
    }
    
    public enum State: Equatable {
        case idle
        case isLoading
        case failure(GetPlaceDetailsError)
        case success(RestaurantDetails)
    }
    
    private let input: Input
    private let getDistanceInKmFromCurrentLocation: (Location) -> Double
    private let getPlaceDetailsService: RestaurantDetailsService
    private let getReviewsService: GetReviewsService
    private var userPlacedReviews = [Review]()

    @Published public var getPlaceDetailsState: State = .idle
    
    public var reviews: [Review] {
        guard case let .success(placeDetails) = getPlaceDetailsState else { return userPlacedReviews }
        return placeDetails.reviews + userPlacedReviews
    }
    
    public var rating: String {
        guard case let .success(placeDetails) = getPlaceDetailsState else { return "" }
        
        return String(format: "%.1f", placeDetails.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        guard case let .success(placeDetails) = getPlaceDetailsState else { return "" }

        let distance = getDistanceInKmFromCurrentLocation(placeDetails.location)
        return "\(distance)"
    }
    
    public init(
        input: Input,
        getDistanceInKmFromCurrentLocation: @escaping (Location) -> Double,
        getPlaceDetailsService: RestaurantDetailsService,
        getReviewsService: GetReviewsService
    ) {
        self.input = input
        self.getDistanceInKmFromCurrentLocation = getDistanceInKmFromCurrentLocation
        self.getPlaceDetailsService = getPlaceDetailsService
        self.getReviewsService = getReviewsService
    }
    
    public func showMaps() {
        guard case let .success(placeDetails) = getPlaceDetailsState else { return }

        let location = placeDetails.location
        guard let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @MainActor public func getPlaceDetails() async {
        getPlaceDetailsState = .isLoading
        
        switch input {
        case let .placeIdToFetch(placeID):
            await fetchPlaceDetails(placeID: placeID)
            
        case let .fetchedPlaceDetails(placeDetails):
            getPlaceDetailsState = .success(placeDetails)
        }
    }
    
    @MainActor private func fetchPlaceDetails(placeID: String) async {
        do {
            let placeDetails = try await getPlaceDetailsService.getRestaurantDetails(placeID: placeID)
            getPlaceDetailsState = .success(placeDetails)
        } catch {
            getPlaceDetailsState = .failure(.serverError)
        }
    }
    
    @MainActor public func getPlaceReviews() async {
        if case let .placeIdToFetch(placeID) = input {
            if let reviews = try? await getReviewsService.getReviews(placeID: placeID) {
                userPlacedReviews = reviews
            }
        }
    }
}
