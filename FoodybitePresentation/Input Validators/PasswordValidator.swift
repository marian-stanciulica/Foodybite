//
//  PasswordValidator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation

public enum PasswordValidator: String, Swift.Error, Equatable {
    case empty = "Empty Password"
    case tooShortPassword = "Too short password"
    case passwordDoesntContainUpperLetter = "Password should contain at least one uppercase letter"
    case passwordDoesntContainLowerLetter = "Password should contain at least one lowercase letter"
    case passwordDoesntContainDigits = "Password should contain at least one digit"
    case passwordDoesntContainSpecialCharacter = "Password should contain at least one special character"
    case passwordsDontMatch = "Passwords do not match"
    
    static func validate(password: String, confirmPassword: String) throws {
        if !containsUpperLetter(password: password) {
            throw passwordDoesntContainUpperLetter
        } else if !containsLowerLetter(password: password) {
            throw passwordDoesntContainLowerLetter
        } else if !containsDigits(password: password) {
            throw passwordDoesntContainDigits
        } else if !containsSpecialCharacters(password: password) {
            throw passwordDoesntContainSpecialCharacter
        } else if password.count < 8 {
            throw tooShortPassword
        }
        
        if password != confirmPassword {
            throw passwordsDontMatch
        }
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
