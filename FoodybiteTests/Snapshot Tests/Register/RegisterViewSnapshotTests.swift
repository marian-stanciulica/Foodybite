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
    
    func test_defaultAppearance() {
        let sut = makeSUT()
        
        assertSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> UIViewController {
        let viewModel = RegisterViewModel(signUpService: EmptySignUpService())
        let registerView = RegisterView(viewModel: viewModel, goToLogin: {})
        let sut = UIHostingController(rootView: registerView)
        return sut
    }
    
    private class EmptySignUpService: SignUpService {
        func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {}
    }
}
 
