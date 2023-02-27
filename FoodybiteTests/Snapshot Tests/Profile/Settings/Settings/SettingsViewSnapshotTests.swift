//
//  SettingsViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 26.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class SettingsViewSnapshotTests: XCTestCase {
    
    func test_settingsViewIdleState() {
        let sut = makeSUT()
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> UIViewController {
        let viewModel = SettingsViewModel(logoutService: EmptyLogoutService(), goToLogin: {})
        let settingsView = SettingsView(viewModel: viewModel, goToChangePassword: {})
        let sut = UIHostingController(rootView: settingsView)
        return sut
    }
    
    private class EmptyLogoutService: LogoutService {
        func logout() async throws {}
    }
}
