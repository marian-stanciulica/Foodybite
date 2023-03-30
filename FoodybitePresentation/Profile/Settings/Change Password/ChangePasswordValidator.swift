//
//  ChangePasswordValidator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation

public class ChangePasswordValidator {
    public enum Error: Swift.Error, Equatable {
        case passwordError(PasswordValidator)
        case serverError
        
        public func toString() -> String {
            switch self {
            case .passwordError(let error):
                return error.rawValue
            case .serverError:
                return "Server error"
            }
        }
    }
    
    static func validate(currentPassword: String, newPassword: String, confirmPassword: String) throws {
        if currentPassword.isEmpty {
            throw PasswordValidator.empty
        }
        
        try PasswordValidator.validate(password: newPassword, confirmPassword: confirmPassword)
    }
}
