//
//  FetchLocationViewSnapshotTests.swift
//  FoodybiteUITests
//
//  Created by Marian Stanciulica on 06.05.2023.
//

import XCTest
import SnapshotTesting
import FoodybiteUI
import FoodybitePresentation
import Domain
import SwiftUI

final class FetchLocationViewSnapshotTests: XCTestCase {

    func test_locationServicesDisabledState() {
        let sut = makeSUT(locationServicesEnabled: false)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_locationServicesEnabledAndIsLoadingState() {
        let sut = makeSUT(state: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_locationServicesEnabledAndFailureState() {
        let sut = makeSUT(state: .failure(.unauthorized))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_locationServicesEnabledAndSuccessState() {
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
