//
//  RegisterValidator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Foundation

public class RegisterValidator {
    public enum RegistrationError: Error {
        case emptyName
        case emptyEmail
        case invalidEmail
        case emptyPassword
        case passwordDoesntContainUpperLetter
        case passwordDoesntContainLowerLetter
        case passwordDoesntContainDigits
        case passwordDoesntContainSpecialCharacter
        case passwordsDontMatch
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
        
        if password.isEmpty {
            throw RegistrationError.emptyPassword
        } else if !containsUpperLetter(password: password) {
            throw RegistrationError.passwordDoesntContainUpperLetter
        } else if !containsLowerLetter(password: password) {
            throw RegistrationError.passwordDoesntContainLowerLetter
        } else if !containsDigits(password: password) {
            throw RegistrationError.passwordDoesntContainDigits
        } else if !containsSpecialCharacters(password: password) {
            throw RegistrationError.passwordDoesntContainSpecialCharacter
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
