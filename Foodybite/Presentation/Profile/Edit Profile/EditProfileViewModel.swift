//
//  EditProfileViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation
import FoodybiteNetworking

public final class EditProfileViewModel {
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
    
    public var name = ""
    public var email = ""
    public var profileImage: Data? = nil
    @Published public var result: Result = .notTriggered

    public init(accountService: AccountService) {
        self.accountService = accountService
    }
    
    public func updateAccount() async {
        if name.isEmpty {
            result = .failure(.emptyName)
        } else if email.isEmpty {
            result = .failure(.emptyEmail)
        } else if !isValid(email: email) {
            result = .failure(.invalidEmail)
        } else {
            do {
                try await accountService.updateAccount(name: name, email: email, profileImage: profileImage)
                result = .success
            } catch {
                result = .failure(.serverError)
            }
        }
    }
    
    private func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}
