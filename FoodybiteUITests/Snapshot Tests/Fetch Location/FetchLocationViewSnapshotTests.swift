//
//  FetchLocationViewSnapshotTests.swift
//  FoodybiteUITests
//
//  Created by Marian Stanciulica on 06.05.2023.
//

import Testing
import SnapshotTesting
import FoodybiteUI
import FoodybitePresentation
import Domain
import SwiftUI

struct FetchLocationViewSnapshotTests {

    @MainActor @Test func locationServicesDisabledState() {
        let sut = makeSUT(locationServicesEnabled: false)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func locationServicesEnabledAndIsLoadingState() {
        let sut = makeSUT(state: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func locationServicesEnabledAndFailureState() {
        let sut = makeSUT(state: .failure(.unauthorized))

        assertLightAndDarkSnapshot(matching: sut)
    }

    @MainActor @Test func locationServicesEnabledAndSuccessState() {
        let sut = makeSUT(state: .success(Location(latitude: 3.4, longitude: 7.6)))

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(locationServicesEnabled: Bool = true, state: FetchLocationViewModel.State = .isLoading) -> some View {
        let viewModel = FetchLocationViewModel(
            locationProvider: EmptyLocationProvider(
                locationServicesEnabled: locationServicesEnabled
            )
        )
        viewModel.state = state

        return FetchLocationView(viewModel: viewModel, username: "Marian") { location in
            Text("Location (\(location.latitude),\(location.longitude)")
                .background(.red)
        }
    }

    private class EmptyLocationProvider: LocationProviding {
        var locationServicesEnabled: Bool

        init(locationServicesEnabled: Bool) {
            self.locationServicesEnabled = locationServicesEnabled
        }

        func requestWhenInUseAuthorization() {}
        func requestLocation() async throws -> Location {
            Location(latitude: 0, longitude: 0)
        }
    }
}
