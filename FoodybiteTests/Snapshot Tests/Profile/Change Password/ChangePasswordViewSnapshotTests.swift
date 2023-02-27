//
//  ChangePasswordViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 26.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class ChangePasswordViewSnapshotTests: XCTestCase {
    
    func test_changePasswordViewIdleState() {
        let sut = makeSUT(state: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_changePasswordViewIsLoadingState() {
        let sut = makeSUT(currentPassword: "12345678",
                          newPassword: "12345678",
                          confirmPassword: "12345678",
                          state: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_changePasswordViewFailureState() {
        let sut = makeSUT(state: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(currentPassword: String = "", newPassword: String = "", confirmPassword: String = "", state: ChangePasswordViewModel.Result) -> UIViewController {
        let viewModel = ChangePasswordViewModel(changePasswordService: EmptyChangePasswordService())
        viewModel.result = state
        viewModel.currentPassword = currentPassword
        viewModel.newPassword = newPassword
        viewModel.confirmPassword = confirmPassword
        let settingsView = ChangePasswordView(viewModel: viewModel)
        let sut = UIHostingController(rootView: settingsView)
        return sut
    }
    
    private class EmptyChangePasswordService: ChangePasswordService {
        func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws {}
    }
}
