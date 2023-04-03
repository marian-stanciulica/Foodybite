//
//  RestaurantReviewCellViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 09.02.2023.
//

import Foundation
import Domain

public class RestaurantReviewCellViewModel: ObservableObject {
    public enum GetPlaceDetailsError: String, Error {
        case serverError = "An error occured while fetching review details. Please try again later!"
    }
    
    public enum State: Equatable {
        case idle
        case isLoading
        case failure(GetPlaceDetailsError)
        case success(RestaurantDetails)
    }
    
    private let review: Review
    private let getPlaceDetailsService: GetPlaceDetailsService
    
    @Published public var getPlaceDetailsState: State = .idle
    
    public var rating: String {
        "\(review.rating)"
    }
    
    public var placeName: String {
        if case let .success(placeDetails) = getPlaceDetailsState {
            return placeDetails.name
        }
        return ""
    }
    
    public var placeAddress: String {
        if case let .success(placeDetails) = getPlaceDetailsState {
            return placeDetails.address
        }
        return ""
    }
    
    public init(review: Review, getPlaceDetailsService: GetPlaceDetailsService) {
        self.review = review
        self.getPlaceDetailsService = getPlaceDetailsService
    }
    
    @MainActor public func getPlaceDetails() async {
        getPlaceDetailsState = .isLoading
        
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: review.placeID)
            getPlaceDetailsState = .success(placeDetails)
        } catch {
            getPlaceDetailsState = .failure(.serverError)
        }
    }
}
