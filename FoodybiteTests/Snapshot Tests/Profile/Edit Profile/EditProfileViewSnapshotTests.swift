//
//  EditProfileViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class EditProfileViewSnapshotTests: XCTestCase {
    
    func test_editProfileViewIdleState() {
        let sut = makeSUT()
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> UIViewController {
        let viewModel = EditProfileViewModel(accountService: EmptyAccountService())
        let editProfileView = EditProfileView(viewModel: viewModel)
        let sut = UIHostingController(rootView: editProfileView)
        return sut
    }
    
    private class EmptyAccountService: AccountService {
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
        func deleteAccount() async throws {}
    }
}
