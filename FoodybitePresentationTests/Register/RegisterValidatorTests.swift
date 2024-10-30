//
//  RegisterValidatorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 12.11.2022.
//

import Testing
import FoodybitePresentation

struct RegisterValidatorTests {

    @Test func registrationError_rawValueOfServerError() {
        #expect(RegisterValidator.Error.serverError.toString() == "There was a problem with the account creation. Please try again later!")
    }

    @Test func registrationError_rawValueOfEmptyNameError() {
        #expect(RegisterValidator.Error.emptyName.toString() == "Empty name")
    }

    @Test func registrationError_rawValueOfEmptyEmailError() {
        #expect(RegisterValidator.Error.emptyEmail.toString() == "Empty email")
    }

    @Test func registrationError_rawValueOfInvalidEmailError() {
        #expect(RegisterValidator.Error.invalidEmail.toString() == "Invalid email")
    }

}
