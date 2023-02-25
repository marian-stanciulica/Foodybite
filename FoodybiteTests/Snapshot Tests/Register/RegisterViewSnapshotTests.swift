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
        let viewModel = RegisterViewModel(signUpService: EmptySignUpService())
        let registerView = RegisterView(viewModel: viewModel, goToLogin: {})
        let controller = UIHostingController(rootView: registerView)
        
        assertSnapshot(matching: controller, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private class EmptySignUpService: SignUpService {
        func signUp(name: String, email: String, password: String, confirmPassword: String, profileImage: Data?) async throws {}
    }
}
 
