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

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    func test_locationServicesEnabledAndIsLoadingState() {
        let sut = makeSUT(state: .isLoading)

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    func test_locationServicesEnabledAndFailureState() {
        let sut = makeSUT(state: .failure(.unauthorized))

        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }

    // MARK: - Helpers

    private func makeSUT(locationServicesEnabled: Bool = true, state: FetchLocationViewModel.State = .isLoading) -> some View {
        let viewModel = FetchLocationViewModel(
            locationProvider: EmptyLocationProvider(
                locationServicesEnabled: locationServicesEnabled
            )
        )
        viewModel.state = state

        return FetchLocationView(viewModel: viewModel, username: "Marian") { _ in
            EmptyView()
                .foregroundColor(.red)
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
