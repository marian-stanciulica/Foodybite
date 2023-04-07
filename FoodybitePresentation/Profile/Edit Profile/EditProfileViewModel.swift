//
//  EditProfileViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Foundation
import Domain

public final class EditProfileViewModel: ObservableObject {
    public enum Error: String, Swift.Error {
        case emptyName = "Empty name"
        case emptyEmail = "Empty email"
        case invalidEmail = "Invalid email"
        case serverError = "Server error"
    }

    public enum State: Equatable {
        case idle
        case isLoading
        case success
        case failure(Error)
    }

    private let accountService: AccountService

    @Published public var name = ""
    @Published public var email = ""
    @Published public var profileImage: Data?
    @Published public var state: State = .idle

    public var isLoading: Bool {
        state == .isLoading
    }

    public init(accountService: AccountService) {
        self.accountService = accountService
    }

    @MainActor public func updateAccount() async {
        state = .isLoading

        if name.isEmpty {
            state = .failure(.emptyName)
        } else if email.isEmpty {
            state = .failure(.emptyEmail)
        } else if !isValid(email: email) {
            state = .failure(.invalidEmail)
        } else {
            do {
                try await accountService.updateAccount(name: name, email: email, profileImage: profileImage)
                state = .success
            } catch {
                state = .failure(.serverError)
            }
        }
    }

    private func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}
