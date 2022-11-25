//
//  ProfileViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation
import FoodybiteNetworking

public final class ProfileViewModel {
    public enum Error: String, Swift.Error {
        case serverError = "Invalid Credentials"
    }
    
    private let accountService: AccountService
    private let goToLogin: () -> Void
    @Published public var error: Error?
    
    public init(accountService: AccountService, goToLogin: @escaping () -> Void) {
        self.accountService = accountService
        self.goToLogin = goToLogin
    }
    
    public func deleteAccount() async {
        do {
            try await accountService.deleteAccount()
            await goToLoginScreen()
        } catch {
            await updateError(.serverError)
        }
    }
    
    @MainActor private func goToLoginScreen() {
        goToLogin()
    }
    
    @MainActor private func updateError(_ newValue: Error) {
        error = newValue
    }
}
