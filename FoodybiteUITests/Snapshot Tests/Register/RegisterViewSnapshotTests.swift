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
import FoodybitePresentation
@testable import FoodybiteUI

final class RegisterViewSnapshotTests: XCTestCase {
    
    func test_registerViewIdleState() {
        let sut = makeSUT(registerResult: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_registerViewIsLoadingState() {
        let sut = makeSUT(name: "Testing",
                          email: "testing@testing.com",
                          password: "12345678",
                          confirmPassword: "12345678",
                          profileImage: UIImage(named: "restaurant_logo_test", in: .current, with: nil)?.pngData(),
                          registerResult: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_registerViewFailureState() {
        let sut = makeSUT(registerResult: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_registerViewSuccessState() {
        let sut = makeSUT(registerResult: .success)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(name: String = "", email: String = "", password: String = "", confirmPassword: String = "", profileImage: Data? = nil, registerResult: RegisterViewModel.State) -> UIViewController {
        let viewModel = RegisterViewModel(signUpService: EmptySignUpService())
        viewModel.name = name
        viewModel.email = email
        viewModel.password = password
        viewModel.confirmPassword = confirmPassword
        viewModel.registerResult = registerResult
        viewModel.profileImage = profileImage
        let registerView = RegisterView(viewModel: viewModel, goToLogin: {})
        let sut = UIHostingController(rootView: registerView)
        return sut
    }
    
    private class EmptySignUpService: SignUpService {
        func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {}
    }
}
 
