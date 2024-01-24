//
//  ChangePasswordViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 26.02.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

final class ChangePasswordViewSnapshotTests: XCTestCase {

    func test_changePasswordViewIdleState() {
        let sut = makeSUT(state: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_changePasswordViewIsLoadingState() {
        let sut = makeSUT(currentPassword: "12345678",
                          newPassword: "12345678",
                          confirmPassword: "12345678",
                          state: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_changePasswordViewFailureState() {
        let sut = makeSUT(state: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_changePasswordViewSuccessState() {
        let sut = makeSUT(state: .success)

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(
        currentPassword: String = "",
        newPassword: String = "",
        confirmPassword: String = "",
        state: ChangePasswordViewModel.Result
    ) -> ChangePasswordView {
        let viewModel = ChangePasswordViewModel(changePasswordService: EmptyChangePasswordService())
        viewModel.result = state
        viewModel.currentPassword = currentPassword
        viewModel.newPassword = newPassword
        viewModel.confirmPassword = confirmPassword
        return ChangePasswordView(viewModel: viewModel)
    }

    private class EmptyChangePasswordService: ChangePasswordService {
        func changePassword(currentPassword: String, newPassword: String) async throws { }
    }
}
