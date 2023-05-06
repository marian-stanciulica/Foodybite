//
//  ChangePasswordValidatorTests.swift
//  FoodybitePresentationTests
//
//  Created by Marian Stanciulica on 06.05.2023.
//

import XCTest
import FoodybitePresentation

final class ChangePasswordValidatorTests: XCTestCase {

    func test_serverError_rawValueOfServerError() {
        XCTAssertEqual(ChangePasswordValidator.Error.serverError.toString(), "Server error")
    }

}
