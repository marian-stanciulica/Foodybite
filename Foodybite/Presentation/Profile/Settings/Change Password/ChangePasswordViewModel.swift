//
//  ChangePasswordViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation
import Domain

public final class ChangePasswordViewModel: ObservableObject {
    private let changePasswordService: ChangePasswordService

    public enum Result: Equatable {
        case idle
        case isLoading
        case failure(ChangePasswordValidator.Error)
        case success
    }
    
    @Published public var currentPassword = ""
    @Published public var newPassword = ""
    @Published public var confirmPassword = ""
    @Published public var result: Result = .idle
    
    public var isLoading: Bool {
        result == .isLoading
    }
    
    public init(changePasswordService: ChangePasswordService) {
        self.changePasswordService = changePasswordService
    }

    @MainActor public func changePassword() async {
        result = .isLoading

        do {
            try ChangePasswordValidator.validate(currentPassword: currentPassword,
                                                 newPassword: newPassword,
                                                 confirmPassword: confirmPassword)
            
            try await makeRequest()
        } catch {
            if let error = error as? ChangePasswordValidator.Error {
                result  = .failure(error)
            } else if let error = error as? PasswordValidator.Error {
                result = .failure(.passwordError(error))
            }
        }
    }
    
    @MainActor private func makeRequest() async throws {
        do {
            try await changePasswordService.changePassword(currentPassword: currentPassword,
                                                           newPassword: newPassword,
                                                           confirmPassword: confirmPassword)
            result = .success
        } catch {
            throw ChangePasswordValidator.Error.serverError
        }
    }
    
}
