//
//  NewReviewViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import Foundation
import Domain

public final class NewReviewViewModel: ObservableObject {
    public enum GetPlaceDetailsError: String, Error {
        case serverError = "An error occured while fetching place details. Please try again later!"
    }
    
    public enum PostReviewError: String, Error {
        case serverError = "Review couldn't be posted. Please try again later!"
    }
    
    public enum GetPlaceDetailsState: Equatable {
        case idle
        case isLoading
        case failure(GetPlaceDetailsError)
        case success(RestaurantDetails)
    }
    
    public enum PostReviewState: Equatable {
        case idle
        case isLoading
        case failure(PostReviewError)
        case success
    }
    
    private let autocompletePlacesService: AutocompleteRestaurantsService
    private let getPlaceDetailsService: RestaurantDetailsService
    private let addReviewService: AddReviewService
    private let location: Location
    private let userPreferences: UserPreferences
    
    @Published public var getPlaceDetailsState: GetPlaceDetailsState = .idle
    @Published public var postReviewState: PostReviewState = .idle
    
    @Published public var searchText = ""
    @Published public var reviewText = ""
    @Published public var starsNumber = 0
    @Published public var autocompleteResults = [AutocompletePrediction]()
    
    public var postReviewEnabled: Bool {
        if case .success = getPlaceDetailsState {
            return !reviewText.isEmpty && starsNumber > 0
        }
        return false
    }
    
    public init(autocompletePlacesService: AutocompleteRestaurantsService, getPlaceDetailsService: RestaurantDetailsService, addReviewService: AddReviewService, location: Location, userPreferences: UserPreferences) {
        self.autocompletePlacesService = autocompletePlacesService
        self.getPlaceDetailsService = getPlaceDetailsService
        self.addReviewService = addReviewService
        self.location = location
        self.userPreferences = userPreferences
    }
    
    @MainActor public func autocomplete() async {
        getPlaceDetailsState = .idle
        
        do {
            autocompleteResults = try await autocompletePlacesService.autocomplete(input: searchText,
                                                                                   location: location,
                                                                                   radius: userPreferences.radius)
        } catch {
            autocompleteResults = []
        }
    }
    
    @MainActor public func getPlaceDetails(placeID: String) async {
        getPlaceDetailsState = .isLoading
        
        do {
            let placeDetails = try await getPlaceDetailsService.getRestaurantDetails(placeID: placeID)
            getPlaceDetailsState = .success(placeDetails)
        } catch {
            getPlaceDetailsState = .failure(.serverError)
        }
    }
    
    @MainActor public func postReview() async {
        guard postReviewEnabled else { return }
        postReviewState = .isLoading
        
        if case let .success(placeDetails) = getPlaceDetailsState {
            do {
                try await addReviewService.addReview(
                    placeID: placeDetails.placeID,
                    reviewText: reviewText,
                    starsNumber: starsNumber,
                    createdAt: Date())
                
                postReviewState = .success
            } catch {
                postReviewState = .failure(.serverError)
            }
        }
    }
}
