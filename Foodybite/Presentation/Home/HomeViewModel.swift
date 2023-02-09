//
//  HomeViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import Domain

public final class HomeViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let searchNearbyService: SearchNearbyService
    private let currentLocation: Location
    
    @Published public var error: Error?
    @Published public var nearbyPlaces = [NearbyPlace]()
    
    public init(searchNearbyService: SearchNearbyService, currentLocation: Location) {
        self.searchNearbyService = searchNearbyService
        self.currentLocation = currentLocation
    }
    
    @MainActor public func searchNearby() async {
        do {
            error = nil
            nearbyPlaces = try await searchNearbyService.searchNearby(location: currentLocation, radius: 10000)
        } catch {
            self.error = .connectionFailure
        }
    }
}
