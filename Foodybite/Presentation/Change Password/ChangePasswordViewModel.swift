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
        case failure(PasswordValidator.Error)
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
            if currentPassword.isEmpty {
                throw PasswordValidator.Error.empty
            }
            
            try PasswordValidator.validate(password: newPassword, confirmPassword: confirmPassword)
            
            try await changePasswordService.changePassword(currentPassword: currentPassword,
                                                           newPassword: newPassword,
                                                           confirmPassword: confirmPassword)
        } catch {
            if let error = error as? PasswordValidator.Error {
                await updateResult(.failure(error))
            }
        }
    }
    
    @MainActor private func updateResult(_ newValue: Result) {
        result = newValue
    }
}
