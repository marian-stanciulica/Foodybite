//
//  RegisterValidator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation

public class RegisterValidator {
    public enum Error: Swift.Error, Equatable {
        case passwordError(PasswordValidator.Error)
        case serverError
        case emptyName
        case emptyEmail
        case invalidEmail
        case passwordsDontMatch
        
        public func toString() -> String {
            switch self {
            case .passwordError(let error):
                return error.rawValue
            case .serverError:
                return "Server error"
            case .emptyName:
                return "Empty name"
            case .emptyEmail:
                return "Empty email"
            case .invalidEmail:
                return "Invalid email"
            case .passwordsDontMatch:
                return "Passwords do not match"
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
        
        try PasswordValidator.validate(password: password)
        
        if password != confirmPassword {
            throw Error.passwordsDontMatch
        }
    }
    
    private static func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    private static func containsUpperLetter(password: String) -> Bool {
        let regex = ".*[A-Z]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private static func containsLowerLetter(password: String) -> Bool {
        let regex = ".*[a-z]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private static func containsDigits(password: String) -> Bool {
        let regex = ".*[0-9]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private static func containsSpecialCharacters(password: String) -> Bool {
        let regex = ".*[.*&^%$#@()/]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
}
