//
//  TabNavigationViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import DomainModels

public final class TabNavigationViewModel {
    public enum State: Equatable {
        case isLoading
        case loadingError(message: String)
        case loaded(location: Location)
    }
    
    private let locationProvider: LocationProviding
    public var state: State = .isLoading
    public var locationServicesEnabled: Bool {
        locationProvider.locationServicesEnabled
    }
    
    public init(locationProvider: LocationProviding) {
        self.locationProvider = locationProvider
    }
    
    public func getCurrentLocation() async {
        state = .isLoading
        
        do {
            let location = try await locationProvider.requestLocation()
            state = .loaded(location: location)
        } catch {
            state = .loadingError(message: "Location couldn't be fetched. Try again!")
        }
    }
}
