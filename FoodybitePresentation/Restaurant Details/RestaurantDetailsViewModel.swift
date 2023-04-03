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
    public enum GetRestaurantDetailsError: String, Swift.Error {
        case serverError = "Server connection failed. Please try again!"
    }
    
    public enum Input {
        case restaurantIdToFetch(String)
        case fetchedRestaurantDetails(RestaurantDetails)
    }
    
    public enum State: Equatable {
        case idle
        case isLoading
        case failure(GetRestaurantDetailsError)
        case success(RestaurantDetails)
    }
    
    private let input: Input
    private let getDistanceInKmFromCurrentLocation: (Location) -> Double
    private let restaurantDetailsService: RestaurantDetailsService
    private let getReviewsService: GetReviewsService
   
    @Published private var userPlacedReviews = [Review]()
    @Published public var getRestaurantDetailsState: State = .idle
    
    public var reviews: [Review] {
        guard case let .success(restaurantDetails) = getRestaurantDetailsState else { return userPlacedReviews }
        return restaurantDetails.reviews + userPlacedReviews
    }
    
    public var rating: String {
        guard case let .success(restaurantDetails) = getRestaurantDetailsState else { return "" }
        
        return String(format: "%.1f", restaurantDetails.rating)
    }
    
    public var distanceInKmFromCurrentLocation: String {
        guard case let .success(restaurantDetails) = getRestaurantDetailsState else { return "" }

        let distance = getDistanceInKmFromCurrentLocation(restaurantDetails.location)
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
        guard case let .success(restaurantDetails) = getRestaurantDetailsState else { return }

        let location = restaurantDetails.location
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
            
        case let .fetchedRestaurantDetails(restaurantDetails):
            getRestaurantDetailsState = .success(restaurantDetails)
        }
    }
    
    @MainActor private func fetchRestaurantDetails(restaurantID: String) async {
        do {
            let restaurantDetails = try await restaurantDetailsService.getRestaurantDetails(restaurantID: restaurantID)
            getRestaurantDetailsState = .success(restaurantDetails)
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
