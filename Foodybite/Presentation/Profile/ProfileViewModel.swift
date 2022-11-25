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
    
    public enum Result: Equatable {
        case notTriggered
        case success
        case failure(Error)
    }
    
    private let accountService: AccountService
    @Published public var result: Result = .notTriggered
    
    public init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    public func deleteAccount() async {
        do {
            try await accountService.deleteAccount()
            await updateResult(.success)
        } catch {
            await updateResult(.failure(.serverError))
        }
    }
    
    @MainActor private func updateResult(_ newValue: Result) {
        result = newValue
    }
}
