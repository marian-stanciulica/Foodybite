//
//  RegisterValidatorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import XCTest
import FoodybitePresentation

final class RegisterValidatorTests: XCTestCase {

    func test_registrationError_rawValueOfServerError() {
        XCTAssertEqual(RegisterValidator.Error.serverError.toString(), "There was a problem with the account creation. Please try again later!")
    }

    func test_registrationError_rawValueOfEmptyNameError() {
        XCTAssertEqual(RegisterValidator.Error.emptyName.toString(), "Empty name")
    }

    func test_registrationError_rawValueOfEmptyEmailError() {
        XCTAssertEqual(RegisterValidator.Error.emptyEmail.toString(), "Empty email")
    }

    func test_registrationError_rawValueOfInvalidEmailError() {
        XCTAssertEqual(RegisterValidator.Error.invalidEmail.toString(), "Invalid email")
    }

}
