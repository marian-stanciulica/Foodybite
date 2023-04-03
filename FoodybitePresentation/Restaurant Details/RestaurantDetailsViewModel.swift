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
        case restaurantIdToFetch(String)
        case fetchedRestaurantDetails(RestaurantDetails)
    }
    
    public enum State: Equatable {
        case idle
        case isLoading
        case failure(GetPlaceDetailsError)
        case success(RestaurantDetails)
    }
    
    private let input: Input
    private let getDistanceInKmFromCurrentLocation: (Location) -> Double
    private let restaurantDetailsService: RestaurantDetailsService
    private let getReviewsService: GetReviewsService
    private var userPlacedReviews = [Review]()

    @Published public var getRestaurantDetailsState: State = .idle
    
    public var reviews: [Review] {
        guard case let .success(placeDetails) = getRestaurantDetailsState else { return userPlacedReviews }
        return placeDetails.reviews + userPlacedReviews
    }
    
    public var rating: String {
        guard case let .success(placeDetails) = getRestaurantDetailsState else { return "" }
        
        return String(format: "%.1f", placeDetails.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        guard case let .success(placeDetails) = getRestaurantDetailsState else { return "" }

        let distance = getDistanceInKmFromCurrentLocation(placeDetails.location)
        return "\(distance)"
    }
    
    public init(
        input: Input,
        getDistanceInKmFromCurrentLocation: @escaping (Location) -> Double,
        restaurantDetailsService: RestaurantDetailsService,
        getReviewsService: GetReviewsService
    ) {
        self.input = input
        self.getDistanceInKmFromCurrentLocation = getDistanceInKmFromCurrentLocation
        self.restaurantDetailsService = restaurantDetailsService
        self.getReviewsService = getReviewsService
    }
    
    public func showMaps() {
        guard case let .success(placeDetails) = getRestaurantDetailsState else { return }

        let location = placeDetails.location
        guard let url = URL(string: "maps://?saddr=&daddr=\(location.latitude),\(location.longitude)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    @MainActor public func getRestaurantDetails() async {
        getRestaurantDetailsState = .isLoading
        
        switch input {
        case let .restaurantIdToFetch(restaurantID):
            await fetchRestaurantDetails(restaurantID: restaurantID)
            
        case let .fetchedRestaurantDetails(placeDetails):
            getRestaurantDetailsState = .success(placeDetails)
        }
    }
    
    @MainActor private func fetchRestaurantDetails(restaurantID: String) async {
        do {
            let placeDetails = try await restaurantDetailsService.getRestaurantDetails(restaurantID: restaurantID)
            getRestaurantDetailsState = .success(placeDetails)
        } catch {
            getRestaurantDetailsState = .failure(.serverError)
        }
    }
    
    @MainActor public func getRestaurantReviews() async {
        if case let .restaurantIdToFetch(restaurantID) = input {
            if let reviews = try? await getReviewsService.getReviews(restaurantID: restaurantID) {
                userPlacedReviews = reviews
            }
        }
    }
}
