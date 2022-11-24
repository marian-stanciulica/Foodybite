//
//  ChangePasswordViewModel.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation
import FoodybiteNetworking

public final class ChangePasswordViewModel {
    private let changePasswordService: ChangePasswordService

    public enum Result: Equatable {
        case notTriggered
        case success
        case failure(ChangePasswordValidator.Error)
    }
    
    public var currentPassword = ""
    public var newPassword = ""
    public var confirmPassword = ""
    @Published public var result: Result = .notTriggered
    
    public init(changePasswordService: ChangePasswordService) {
        self.changePasswordService = changePasswordService
    }

    public func changePassword() async {
        do {
            try ChangePasswordValidator.validate(currentPassword: currentPassword,
                                                 newPassword: newPassword,
                                                 confirmPassword: confirmPassword)
            
            try await makeRequest()
        } catch {
            if let error = error as? ChangePasswordValidator.Error {
                await updateResult(.failure(error))
            } else if let error = error as? PasswordValidator.Error {
                await updateResult(.failure(.passwordError(error)))
            }
        }
    }
    
    private func makeRequest() async throws {
        do {
            try await changePasswordService.changePassword(currentPassword: currentPassword,
                                                           newPassword: newPassword,
                                                           confirmPassword: confirmPassword)
            await updateResult(.success)
        } catch {
            throw ChangePasswordValidator.Error.serverError
        }
    }
    
    @MainActor private func updateResult(_ newValue: Result) {
        result = newValue
    }
}
