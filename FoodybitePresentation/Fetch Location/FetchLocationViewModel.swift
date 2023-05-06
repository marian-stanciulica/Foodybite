//
//  FetchLocationViewModel.swift
//  FoodybitePresentation
//
//  Created by Marian Stanciulica on 06.05.2023.
//

import Foundation
import Domain

public final class FetchLocationViewModel: ObservableObject {
    public enum LocationLoadingError: String, Error {
        case unauthorized = "Location couldn't be fetched. Try again!"
    }

    public enum State: Equatable {
        case isLoading
        case failure(LocationLoadingError)
        case success(Location)
    }

    @Published public var locationProvider: LocationProviding
    @Published public var state: State = .isLoading

    public var locationServicesEnabled: Bool {
        locationProvider.locationServicesEnabled
    }

    public init(locationProvider: LocationProviding) {
        self.locationProvider = locationProvider
    }

    @MainActor public func getCurrentLocation() async {
        state = .isLoading

        do {
            let location = try await locationProvider.requestLocation()
            state = .success(location)
        } catch {
            state = .failure(.unauthorized)
        }
    }
}
