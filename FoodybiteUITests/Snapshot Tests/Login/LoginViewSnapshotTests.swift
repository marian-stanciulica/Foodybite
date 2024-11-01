//
//  LoginViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.02.2023.
//

import XCTest
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

final class LoginViewSnapshotTests: XCTestCase {

    func test_loginViewIdleState() {
        let sut = makeSUT(state: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_loginViewIsLoadingState() {
        let sut = makeSUT(email: "testing@testing.com",
                          password: "12345678",
                          state: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_loginViewFailureState() {
        let sut = makeSUT(state: .failure(.serverError))

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(email: String = "", password: String = "", state: LoginViewModel.State) -> LoginView {
        let viewModel = LoginViewModel(loginService: EmptyLoginService(), goToMainTab: { _ in })
        viewModel.email = email
        viewModel.password = password
        viewModel.state = state
        return LoginView(viewModel: viewModel, goToSignUp: {})
    }

    private class EmptyLoginService: LoginService {
        func login(email: String, password: String) async throws -> User {
            User(id: UUID(), name: "", email: "", profileImage: nil)
        }
    }
}
