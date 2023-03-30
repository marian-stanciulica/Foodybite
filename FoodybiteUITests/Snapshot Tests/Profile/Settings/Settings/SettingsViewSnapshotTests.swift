//
//  SettingsViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 26.02.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

final class SettingsViewSnapshotTests: XCTestCase {
    
    func test_settingsViewIdleState() {
        let sut = makeSUT()
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
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
