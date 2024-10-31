//
//  RegisterViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.02.2023.
//

import UIKit
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

struct RegisterViewSnapshotTests {

    func test_registerViewIdleState() {
        let sut = makeSUT(registerResult: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_registerViewIsLoadingState() {
        let sut = makeSUT(name: "Testing",
                          email: "testing@testing.com",
                          password: "12345678",
                          confirmPassword: "12345678",
                          profileImage: UIImage(named: "restaurant_logo_test", in: .current, with: nil)?.pngData(),
                          registerResult: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_registerViewFailureState() {
        let sut = makeSUT(registerResult: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))

        assertLightAndDarkSnapshot(matching: sut)
    }

    func test_registerViewSuccessState() {
        let sut = makeSUT(registerResult: .success)

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(
        name: String = "",
        email: String = "",
        password: String = "",
        confirmPassword: String = "",
        profileImage: Data? = nil,
        registerResult: RegisterViewModel.State
    ) -> RegisterView {
        let viewModel = RegisterViewModel(signUpService: EmptySignUpService())
        viewModel.name = name
        viewModel.email = email
        viewModel.password = password
        viewModel.confirmPassword = confirmPassword
        viewModel.registerResult = registerResult
        viewModel.profileImage = profileImage
        return RegisterView(viewModel: viewModel, goToLogin: {})
    }

    private class EmptySignUpService: SignUpService {
        func signUp(name: String, email: String, password: String, profileImage: Data?) async throws {}
    }
}
