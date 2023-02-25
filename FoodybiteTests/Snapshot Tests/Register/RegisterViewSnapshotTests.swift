//
//  RegisterViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class RegisterViewSnapshotTests: XCTestCase {
    
    func test_idleRegisterView() {
        let sut = makeSUT(registerResult: .idle)
        
        assertSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_isLoadingRegisterView() {
        let sut = makeSUT(name: "Testing",
                          email: "testing@testing.com",
                          password: "12345678",
                          confirmPassword: "12345678",
                          registerResult: .isLoading)
        
        assertSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(name: String = "", email: String = "", password: String = "", confirmPassword: String = "", registerResult: RegisterViewModel.State) -> UIViewController {
        let viewModel = RegisterViewModel(signUpService: EmptySignUpService())
        viewModel.name = name
        viewModel.email = email
        viewModel.password = password
        viewModel.confirmPassword = confirmPassword
        viewModel.registerResult = registerResult
        let registerView = RegisterView(viewModel: viewModel, goToLogin: {})
        let sut = UIHostingController(rootView: registerView)
        return sut
    }
    
    private class EmptySignUpService: SignUpService {
        func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {}
    }
}
 
