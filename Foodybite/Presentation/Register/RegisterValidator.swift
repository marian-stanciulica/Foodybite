//
//  RegisterValidator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation

public class RegisterValidator {
    public enum RegistrationError: String, Error {
        case serverError = "Server error"
        case emptyName = "Empty name"
        case emptyEmail = "Empty email"
        case invalidEmail = "Invalid email"
        case tooShortPassword = "Too short password"
        case passwordDoesntContainUpperLetter = "Password should contain at least one uppercase letter"
        case passwordDoesntContainLowerLetter = "Password should contain at least one lowercase letter"
        case passwordDoesntContainDigits = "Password should contain at least one digit"
        case passwordDoesntContainSpecialCharacter = "Password should contain at least one special character"
        case passwordsDontMatch = "Passwords do not match"
    }
    
    func validate(name: String, email: String, password: String, confirmPassword: String) throws {
        if name.isEmpty {
            throw RegistrationError.emptyName
        }
        
        if email.isEmpty {
            throw RegistrationError.emptyEmail
        } else if !isValid(email: email) {
            throw RegistrationError.invalidEmail
        }
        
        if !containsUpperLetter(password: password) {
            throw RegistrationError.passwordDoesntContainUpperLetter
        } else if !containsLowerLetter(password: password) {
            throw RegistrationError.passwordDoesntContainLowerLetter
        } else if !containsDigits(password: password) {
            throw RegistrationError.passwordDoesntContainDigits
        } else if !containsSpecialCharacters(password: password) {
            throw RegistrationError.passwordDoesntContainSpecialCharacter
        } else if password.count < 8 {
            throw RegistrationError.tooShortPassword
        }
        
        if password != confirmPassword {
            throw RegistrationError.passwordsDontMatch
        }
    }
    
    private func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    private func containsUpperLetter(password: String) -> Bool {
        let regex = ".*[A-Z]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func containsLowerLetter(password: String) -> Bool {
        let regex = ".*[a-z]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func containsDigits(password: String) -> Bool {
        let regex = ".*[0-9]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func containsSpecialCharacters(password: String) -> Bool {
        let regex = ".*[.*&^%$#@()/]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
}
