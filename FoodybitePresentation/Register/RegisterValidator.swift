//
//  RegisterValidator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation

public class RegisterValidator {
    public enum Error: Swift.Error, Equatable {
        case passwordError(PasswordValidator)
        case serverError
        case emptyName
        case emptyEmail
        case invalidEmail

        public func toString() -> String {
            switch self {
            case .passwordError(let error):
                return error.rawValue
            case .serverError:
                return "There was a problem with the account creation. Please try again later!"
            case .emptyName:
                return "Empty name"
            case .emptyEmail:
                return "Empty email"
            case .invalidEmail:
                return "Invalid email"
            }
        }
    }

    static func validate(name: String, email: String, password: String, confirmPassword: String) throws {
        if name.isEmpty {
            throw Error.emptyName
        }

        if email.isEmpty {
            throw Error.emptyEmail
        } else if !isValid(email: email) {
            throw Error.invalidEmail
        }

        try PasswordValidator.validate(password: password, confirmPassword: confirmPassword)
    }

    private static func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}
