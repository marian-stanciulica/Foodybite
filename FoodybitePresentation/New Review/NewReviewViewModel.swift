//
//  NewReviewViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import Foundation
import Domain

public final class NewReviewViewModel: ObservableObject {
    public enum RestaurantDetailsError: String, Error {
        case serverError = "An error occured while fetching restaurant details. Please try again later!"
    }

    public enum PostReviewError: String, Error {
        case serverError = "Review couldn't be posted. Please try again later!"
    }

    public enum RestaurantDetailsState: Equatable {
        case idle
        case isLoading
        case failure(RestaurantDetailsError)
        case success(RestaurantDetails)
    }

    public enum PostReviewState: Equatable {
        case idle
        case isLoading
        case failure(PostReviewError)
        case success
    }

    private let autocompleteRestaurantsService: AutocompleteRestaurantsService
    private let restaurantDetailsService: RestaurantDetailsService
    private let addReviewService: AddReviewService
    private let location: Location
    private let userPreferences: UserPreferences

    @Published public var getRestaurantDetailsState: RestaurantDetailsState = .idle
    @Published public var postReviewState: PostReviewState = .idle

    @Published public var searchText = ""
    @Published public var reviewText = ""
    @Published public var starsNumber = 0
    @Published public var autocompleteResults = [AutocompletePrediction]()

    public var postReviewEnabled: Bool {
        if case .success = getRestaurantDetailsState {
            return !reviewText.isEmpty && starsNumber > 0
        }
        return false
    }

    public init(
        autocompleteRestaurantsService: AutocompleteRestaurantsService,
        restaurantDetailsService: RestaurantDetailsService,
        addReviewService: AddReviewService,
        location: Location,
        userPreferences: UserPreferences
    ) {
        self.autocompleteRestaurantsService = autocompleteRestaurantsService
        self.restaurantDetailsService = restaurantDetailsService
        self.addReviewService = addReviewService
        self.location = location
        self.userPreferences = userPreferences
    }

    @MainActor public func autocomplete() async {
        getRestaurantDetailsState = .idle

        do {
            autocompleteResults = try await autocompleteRestaurantsService.autocomplete(input: searchText,
                                                                                   location: location,
                                                                                   radius: userPreferences.radius)
        } catch {
            autocompleteResults = []
        }
    }

    @MainActor public func getRestaurantDetails(restaurantID: String) async {
        getRestaurantDetailsState = .isLoading

        do {
            let restaurantDetails = try await restaurantDetailsService.getRestaurantDetails(restaurantID: restaurantID)
            getRestaurantDetailsState = .success(restaurantDetails)
        } catch {
            getRestaurantDetailsState = .failure(.serverError)
        }
    }

    @MainActor public func postReview() async {
        guard postReviewEnabled else { return }
        postReviewState = .isLoading

        if case let .success(restaurantDetails) = getRestaurantDetailsState {
            do {
                try await addReviewService.addReview(
                    restaurantID: restaurantDetails.id,
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
