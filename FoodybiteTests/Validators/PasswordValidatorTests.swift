//
//  PasswordValidatorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import XCTest
import Foodybite

final class PasswordValidatorTests: XCTestCase {

    func test_registrationError_rawValueOfTooShortPasswordError() {
        XCTAssertEqual(PasswordValidator.Error.tooShortPassword.rawValue, "Too short password")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainUpperLetterError() {
        XCTAssertEqual(PasswordValidator.Error.passwordDoesntContainUpperLetter.rawValue, "Password should contain at least one uppercase letter")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainLowerLetterError() {
        XCTAssertEqual(PasswordValidator.Error.passwordDoesntContainLowerLetter.rawValue, "Password should contain at least one lowercase letter")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainDigitsError() {
        XCTAssertEqual(PasswordValidator.Error.passwordDoesntContainDigits.rawValue, "Password should contain at least one digit")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainSpecialCharacterError() {
        XCTAssertEqual(PasswordValidator.Error.passwordDoesntContainSpecialCharacter.rawValue, "Password should contain at least one special character")
    }

}
