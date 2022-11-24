//
//  PasswordValidator.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Foundation

public class PasswordValidator {
    public enum Error: String, Swift.Error, Equatable {
        case tooShortPassword = "Too short password"
        case passwordDoesntContainUpperLetter = "Password should contain at least one uppercase letter"
        case passwordDoesntContainLowerLetter = "Password should contain at least one lowercase letter"
        case passwordDoesntContainDigits = "Password should contain at least one digit"
        case passwordDoesntContainSpecialCharacter = "Password should contain at least one special character"
        case passwordsDontMatch = "Passwords do not match"
    }
    
    private init() {}
    
    static func validate(password: String, confirmPassword: String) throws {
        if !containsUpperLetter(password: password) {
            throw Error.passwordDoesntContainUpperLetter
        } else if !containsLowerLetter(password: password) {
            throw Error.passwordDoesntContainLowerLetter
        } else if !containsDigits(password: password) {
            throw Error.passwordDoesntContainDigits
        } else if !containsSpecialCharacters(password: password) {
            throw Error.passwordDoesntContainSpecialCharacter
        } else if password.count < 8 {
            throw Error.tooShortPassword
        }
        
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
