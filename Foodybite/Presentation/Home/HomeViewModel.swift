//
//  HomeViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import DomainModels

public final class HomeViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let searchNearbyService: SearchNearbyService
    @Published public var error: Error?
    @Published public var nearbyPlaces = [NearbyPlace]()
    
    public init(searchNearbyService: SearchNearbyService) {
        self.searchNearbyService = searchNearbyService
    }
    
    @MainActor public func searchNearby(location: Location, radius: Int) async {
        do {
            error = nil
            nearbyPlaces = try await searchNearbyService.searchNearby(location: location, radius: radius)
        } catch {
            self.error = .connectionFailure
        }
    }
}
