//
//  EditProfileViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import Testing
import UIKit
import Foundation
import SnapshotTesting
import Domain
import FoodybitePresentation
import FoodybiteUI

struct EditProfileViewSnapshotTests {

    @Test func editProfileViewIdleState() {
        let sut = makeSUT(state: .idle)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @Test func editProfileViewIsLoadingState() {
        let sut = makeSUT(name: "Testing",
                          email: "testing@testing.com",
                          profileImage: UIImage.make(withColor: .red).pngData(),
                          state: .isLoading)

        assertLightAndDarkSnapshot(matching: sut)
    }

    @Test func editProfileViewFailureState() {
        let sut = makeSUT(state: .failure(.invalidEmail))

        assertLightAndDarkSnapshot(matching: sut)
    }

    @Test func editProfileViewSuccessState() {
        let sut = makeSUT(state: .success)

        assertLightAndDarkSnapshot(matching: sut)
    }

    // MARK: - Helpers

    private func makeSUT(name: String = "", email: String = "", profileImage: Data? = nil, state: EditProfileViewModel.State) -> EditProfileView {
        let viewModel = EditProfileViewModel(accountService: EmptyAccountService())
        viewModel.name = name
        viewModel.email = email
        viewModel.profileImage = profileImage
        viewModel.state = state
        return EditProfileView(viewModel: viewModel)
    }

    private class EmptyAccountService: AccountService {
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
        func deleteAccount() async throws {}
    }
}
