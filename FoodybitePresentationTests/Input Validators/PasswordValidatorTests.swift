//
//  PasswordValidatorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import XCTest
import FoodybitePresentation

final class PasswordValidatorTests: XCTestCase {

    func test_registrationError_rawValueOfEmptyPasswordError() {
        XCTAssertEqual(PasswordValidator.empty.rawValue, "Empty Password")
    }

    func test_registrationError_rawValueOfTooShortPasswordError() {
        XCTAssertEqual(PasswordValidator.tooShortPassword.rawValue, "Too short password")
    }

    func test_registrationError_rawValueOfPasswordDoesntContainUpperLetterError() {
        XCTAssertEqual(PasswordValidator.passwordDoesntContainUpperLetter.rawValue, "Password should contain at least one uppercase letter")
    }

    func test_registrationError_rawValueOfPasswordDoesntContainLowerLetterError() {
        XCTAssertEqual(PasswordValidator.passwordDoesntContainLowerLetter.rawValue, "Password should contain at least one lowercase letter")
    }

    func test_registrationError_rawValueOfPasswordDoesntContainDigitsError() {
        XCTAssertEqual(PasswordValidator.passwordDoesntContainDigits.rawValue, "Password should contain at least one digit")
    }

    func test_registrationError_rawValueOfPasswordDoesntContainSpecialCharacterError() {
        XCTAssertEqual(PasswordValidator.passwordDoesntContainSpecialCharacter.rawValue, "Password should contain at least one special character")
    }

    func test_registrationError_rawValueOfPasswordsDontMatchError() {
        XCTAssertEqual(PasswordValidator.passwordsDontMatch.rawValue, "Passwords do not match")
    }

}
