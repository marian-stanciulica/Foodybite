//
//  HomeViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import Domain

public final class HomeViewModel: ObservableObject {
    public enum SearchNearbyError: String, Swift.Error {
        case serverError = "Server connection failed. Please try again!"
    }

    public enum State: Equatable {
        case idle
        case isLoading
        case failure(SearchNearbyError)
        case success([NearbyRestaurant])
    }

    private let nearbyRestaurantsService: NearbyRestaurantsService
    private let currentLocation: Location
    private let userPreferences: UserPreferences

    @Published public var searchNearbyState: State = .idle
    @Published public var searchText = ""

    public var filteredNearbyRestaurants: [NearbyRestaurant] {
        guard case let .success(nearbyRestaurants) = searchNearbyState else { return [] }

        if searchText.isEmpty {
            return nearbyRestaurants
        }

        return nearbyRestaurants.filter { $0.name.contains(searchText) }
    }

    public init(nearbyRestaurantsService: NearbyRestaurantsService, currentLocation: Location, userPreferences: UserPreferences) {
        self.nearbyRestaurantsService = nearbyRestaurantsService
        self.currentLocation = currentLocation
        self.userPreferences = userPreferences
    }

    @MainActor public func searchNearby() async {
        searchNearbyState = .isLoading

        do {
            let nearbyRestaurants = try await nearbyRestaurantsService.searchNearby(location: currentLocation, radius: userPreferences.radius)
            searchNearbyState = .success(nearbyRestaurants)
        } catch {
            searchNearbyState = .failure(.serverError)
        }
    }
}
