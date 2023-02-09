//
//  ProfileViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation
import Domain

public final class ProfileViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case accountDeletionError = "An error occured during deletion. Please try again!"
    }
    
    public enum State: Equatable {
        case idle
    }
    
    private let accountService: AccountService
    private let goToLogin: () -> Void
    let user: User

    @Published public var getReviewsState: State = .idle
    @Published public var error: Error?
    
    public init(accountService: AccountService, user: User, goToLogin: @escaping () -> Void) {
        self.accountService = accountService
        self.user = user
        self.goToLogin = goToLogin
    }
    
    @MainActor public func deleteAccount() async {
        do {
            try await accountService.deleteAccount()
            goToLogin()
        } catch {
            self.error = Error.accountDeletionError
        }
    }
}
