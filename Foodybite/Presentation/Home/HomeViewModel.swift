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
        case success([NearbyPlace])
    }
    
    private let searchNearbyService: SearchNearbyService
    private let currentLocation: Location
    
    @Published public var searchNearbyState: State = .idle
    @Published public var searchText = ""
    
    public var filteredNearbyPlaces: [NearbyPlace] {
        guard case let .success(nearbyPlaces) = searchNearbyState else { return [] }
        
        if searchText.isEmpty {
            return nearbyPlaces
        }
        
        return nearbyPlaces.filter { $0.placeName.contains(searchText) }
    }
    
    public init(searchNearbyService: SearchNearbyService, currentLocation: Location) {
        self.searchNearbyService = searchNearbyService
        self.currentLocation = currentLocation
    }
    
    @MainActor public func searchNearby() async {
        searchNearbyState = .isLoading
        
        do {
            let nearbyPlaces = try await searchNearbyService.searchNearby(location: currentLocation, radius: 10000)
            searchNearbyState = .success(nearbyPlaces)
        } catch {
            searchNearbyState = .failure(.serverError)
        }
    }
}
