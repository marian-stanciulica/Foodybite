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
import FoodybitePresentation
@testable import FoodybiteUI

final class EditProfileViewSnapshotTests: XCTestCase {
    
    func test_editProfileViewIdleState() {
        let sut = makeSUT(state: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_editProfileViewIsLoadingState() {
        let sut = makeSUT(name: "Testing",
                          email: "testing@testing.com",
                          profileImage: UIImage.make(withColor: .red).pngData(),
                          state: .isLoading)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_editProfileViewFailureState() {
        let sut = makeSUT(state: .failure(.invalidEmail))
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_editProfileViewSuccessState() {
        let sut = makeSUT(state: .success)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(name: String = "", email: String = "", profileImage: Data? = nil, state: EditProfileViewModel.State) -> UIViewController {
        let viewModel = EditProfileViewModel(accountService: EmptyAccountService())
        viewModel.name = name
        viewModel.email = email
        viewModel.profileImage = profileImage
        viewModel.state = state
        let editProfileView = EditProfileView(viewModel: viewModel)
        let sut = UIHostingController(rootView: editProfileView)
        return sut
    }
    
    private class EmptyAccountService: AccountService {
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
        func deleteAccount() async throws {}
    }
}
