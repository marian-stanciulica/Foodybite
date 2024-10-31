//
//  SettingsViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 26.02.2023.
//

import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

struct SettingsViewSnapshotTests {

    func test_settingsViewIdleState() {
        let sut = makeSUT()

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT() -> SettingsView {
        let viewModel = SettingsViewModel(logoutService: EmptyLogoutService(), goToLogin: {})
        return SettingsView(viewModel: viewModel, goToChangePassword: {})
    }

    private class EmptyLogoutService: LogoutService {
        func logout() async throws {}
    }
}
