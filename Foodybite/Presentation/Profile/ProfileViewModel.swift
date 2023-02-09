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
        case serverError = "Invalid Credentials"
    }
    
    private let accountService: AccountService
    private let goToLogin: () -> Void
    @Published public var error: Error?
    let user: User
    
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
            self.error = Error.serverError
        }
    }
}
