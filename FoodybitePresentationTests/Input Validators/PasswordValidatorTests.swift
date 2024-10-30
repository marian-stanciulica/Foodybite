//
//  PasswordValidatorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Testing
import FoodybitePresentation

struct PasswordValidatorTests {

    @Test func registrationError_rawValueOfEmptyPasswordError() {
        #expect(PasswordValidator.empty.rawValue == "Empty Password")
    }

    @Test func registrationError_rawValueOfTooShortPasswordError() {
        #expect(PasswordValidator.tooShortPassword.rawValue == "Too short password")
    }

    @Test func registrationError_rawValueOfPasswordDoesntContainUpperLetterError() {
        #expect(PasswordValidator.passwordDoesntContainUpperLetter.rawValue == "Password should contain at least one uppercase letter")
    }

    @Test func registrationError_rawValueOfPasswordDoesntContainLowerLetterError() {
        #expect(PasswordValidator.passwordDoesntContainLowerLetter.rawValue == "Password should contain at least one lowercase letter")
    }

    @Test func registrationError_rawValueOfPasswordDoesntContainDigitsError() {
        #expect(PasswordValidator.passwordDoesntContainDigits.rawValue == "Password should contain at least one digit")
    }

    @Test func registrationError_rawValueOfPasswordDoesntContainSpecialCharacterError() {
        #expect(PasswordValidator.passwordDoesntContainSpecialCharacter.rawValue == "Password should contain at least one special character")
    }

    @Test func registrationError_rawValueOfPasswordsDontMatchError() {
        #expect(PasswordValidator.passwordsDontMatch.rawValue == "Passwords do not match")
    }

}
