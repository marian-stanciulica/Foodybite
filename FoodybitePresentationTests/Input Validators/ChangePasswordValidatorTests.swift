//
//  ChangePasswordValidatorTests.swift
//  FoodybitePresentationTests
//
//  Created by Marian Stanciulica on 06.05.2023.
//

import Testing
import FoodybitePresentation

struct ChangePasswordValidatorTests {

    @Test func serverError_rawValueOfServerError() {
        #expect(ChangePasswordValidator.Error.serverError.toString() == "Server error")
    }

}
