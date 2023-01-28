//
//  HomeViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Foundation
import DomainModels

public final class HomeViewModel {
    public enum Error: String, Swift.Error {
        case connectionFailure = "Server connection failed. Please try again!"
    }
    
    private let searchNearbyService: SearchNearbyService
    public var error: Error?
    public var nearbyPlaces = [NearbyPlace]()
    
    public init(searchNearbyService: SearchNearbyService) {
        self.searchNearbyService = searchNearbyService
    }
    
    public func searchNearby(location: Location, radius: Int) async {
        do {
            error = nil
            nearbyPlaces = try await searchNearbyService.searchNearby(location: location, radius: radius)
        } catch {
            self.error = .connectionFailure
        }
    }
}
