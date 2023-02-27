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
    
    public enum State: Equatable {
        case idle
        case isLoading
        case failure(GetPlaceDetailsError)
        case success(PlaceDetails)
    }
    
    public enum ReviewState: Equatable {
        case idle
        case isLoading
        case loadingError(String)
        case requestSucceeeded
    }
    
    private let autocompletePlacesService: AutocompletePlacesService
    private let getPlaceDetailsService: GetPlaceDetailsService
    private let addReviewService: AddReviewService
    private let location: Location
    
    @Published public var getPlaceDetailsState: State = .idle
    @Published public var postReviewState: ReviewState = .idle
    
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
    
    public init(autocompletePlacesService: AutocompletePlacesService, getPlaceDetailsService: GetPlaceDetailsService, addReviewService: AddReviewService, location: Location) {
        self.autocompletePlacesService = autocompletePlacesService
        self.getPlaceDetailsService = getPlaceDetailsService
        self.addReviewService = addReviewService
        self.location = location
    }
    
    @MainActor public func autocomplete() async {
        getPlaceDetailsState = .idle
        
        do {
            autocompleteResults = try await autocompletePlacesService.autocomplete(input: searchText, location: location, radius: 100)
        } catch {
            autocompleteResults = []
        }
    }
    
    @MainActor public func getPlaceDetails(placeID: String) async {
        getPlaceDetailsState = .isLoading
        
        do {
            let placeDetails = try await getPlaceDetailsService.getPlaceDetails(placeID: placeID)
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
                
                postReviewState = .requestSucceeeded
            } catch {
                postReviewState = .loadingError("Review couldn't be posted. Please try again later!")
            }
        }
    }
}
