//
//  EditProfileViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation
import FoodybiteNetworking

public final class EditProfileViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case emptyName = "Empty name"
        case emptyEmail = "Empty email"
        case invalidEmail = "Invalid email"
        case serverError = "Server error"
    }
    
    public enum Result: Equatable {
        case notTriggered
        case success
        case failure(Error)
    }
    
    private let accountService: AccountService
    
    @Published public var name = ""
    @Published public var email = ""
    @Published public var profileImage: Data? = nil
    @Published public var result: Result = .notTriggered

    public init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    public func updateAccount() async {
        if name.isEmpty {
            await updateResult(.failure(.emptyName))
        } else if email.isEmpty {
            await updateResult(.failure(.emptyEmail))
        } else if !isValid(email: email) {
            await updateResult(.failure(.invalidEmail))
        } else {
            do {
                try await accountService.updateAccount(name: name, email: email, profileImage: profileImage)
                await updateResult(.success)
            } catch {
                await updateResult(.failure(.serverError))
            }
        }
    }
    
    @MainActor private func updateResult(_ newValue: Result) {
        result = newValue
    }
    
    private func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}
