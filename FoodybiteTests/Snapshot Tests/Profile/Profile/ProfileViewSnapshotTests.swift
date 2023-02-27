//
//  ProfileViewSnapshotTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 27.02.2023.
//

import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import Foodybite

final class ProfileViewSnapshotTests: XCTestCase {
    
    func test_profileViewIdleStateForUserWithoutProfileImage() {
        let sut = makeSUT(user: makeUserWithoutProfileImage(),
                          state: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    func test_profileViewIdleStateForUserWithProfileImage() {
        let sut = makeSUT(user: makeUserWithProfileImage(),
                          state: .idle)
        
        assertLightSnapshot(matching: sut, as: .image(on: .iPhone13))
        assertDarkSnapshot(matching: sut, as: .image(on: .iPhone13))
    }
    
    // MARK: - Helpers
    
    private func makeSUT(user: User, state: EditProfileViewModel.State) -> UIViewController {
        let viewModel = ProfileViewModel(accountService: EmptyAccountService(), getReviewsService: EmptyGetReviewsService(), user: user, goToLogin: {})
        let profileView = ProfileView(viewModel: viewModel, cell: { _ in EmptyView() }, goToSettings: {}, goToEditProfile: {})
        let sut = UIHostingController(rootView: profileView)
        return sut
    }
    
    private func makeUserWithoutProfileImage() -> User {
        User(id: UUID(),
             name: "Testing",
             email: "testing@testing.com",
             profileImage: nil)
    }
    
    private func makeUserWithProfileImage() -> User {
        User(id: UUID(),
             name: "Testing",
             email: "testing@testing.com",
             profileImage: UIImage.make(withColor: .red).pngData())
    }
    
    private class EmptyAccountService: AccountService {
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
        func deleteAccount() async throws {}
    }
    
    private class EmptyGetReviewsService: GetReviewsService {
        func getReviews(placeID: String?) async throws -> [Review] {
            []
        }
    }
}
