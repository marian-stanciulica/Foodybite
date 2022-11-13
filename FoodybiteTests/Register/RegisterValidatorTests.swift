//
//  RegisterValidatorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import XCTest
import Foodybite

final class RegisterValidatorTests: XCTestCase {
    
    func test_registrationError_rawValueOfServerError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.serverError.rawValue, "Server error")
    }
    
    func test_registrationError_rawValueOfEmptyNameError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.emptyName.rawValue, "Empty name")
    }
    
    func test_registrationError_rawValueOfEmptyEmailError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.emptyEmail.rawValue, "Empty email")
    }
    
    func test_registrationError_rawValueOfInvalidEmailError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.invalidEmail.rawValue, "Invalid email")
    }
    
    func test_registrationError_rawValueOfTooShortPasswordError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.tooShortPassword.rawValue, "Too short password")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainUpperLetterError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.passwordDoesntContainUpperLetter.rawValue, "Password should contain at least one uppercase letter")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainLowerLetterError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.passwordDoesntContainLowerLetter.rawValue, "Password should contain at least one lowercase letter")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainDigitsError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.passwordDoesntContainDigits.rawValue, "Password should contain at least one digit")
    }
    
    func test_registrationError_rawValueOfPasswordDoesntContainSpecialCharacterError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.passwordDoesntContainSpecialCharacter.rawValue, "Password should contain at least one special character")
    }
    
    func test_registrationError_rawValueOfPasswordsDontMatchError() {
        XCTAssertEqual(RegisterValidator.RegistrationError.passwordsDontMatch.rawValue, "Passwords do not match")
    }
    
}
