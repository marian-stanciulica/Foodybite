//
//  RestaurantReviewCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import Foundation
import Domain

public class RestaurantReviewCellViewModel: ObservableObject {
    public enum GetRestaurantDetailsError: String, Error {
        case serverError = "An error occured while fetching review details. Please try again later!"
    }
    
    public enum State: Equatable {
        case idle
        case isLoading
        case failure(GetRestaurantDetailsError)
        case success(RestaurantDetails)
    }
    
    private let review: Review
    private let restaurantDetailsService: RestaurantDetailsService
    
    @Published public var getRestaurantDetailsState: State = .idle
    
    public var rating: String {
        "\(review.rating)"
    }
    
    public var restaurantName: String {
        if case let .success(restaurantDetails) = getRestaurantDetailsState {
            return restaurantDetails.name
        }
        return ""
    }
    
    public var restaurantAddress: String {
        if case let .success(restaurantDetails) = getRestaurantDetailsState {
            return restaurantDetails.address
        }
        return ""
    }
    
    public init(review: Review, restaurantDetailsService: RestaurantDetailsService) {
        self.review = review
        self.restaurantDetailsService = restaurantDetailsService
    }
    
    @MainActor public func getRestaurantDetails() async {
        getRestaurantDetailsState = .isLoading
        
        do {
            let placeDetails = try await restaurantDetailsService.getRestaurantDetails(restaurantID: review.restaurantID)
            getRestaurantDetailsState = .success(placeDetails)
        } catch {
            getRestaurantDetailsState = .failure(.serverError)
        }
    }
}
