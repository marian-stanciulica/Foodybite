//
//  RegisterViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 11.11.2022.
//

import XCTest
import Combine

class RegisterViewModel {
    
    enum RegistrationError: Error {
        case emptyName
    }
    
    func register() throws {
        throw RegistrationError.emptyName
    }
    
}

final class RegisterViewModelTests: XCTestCase {

    func test_register_triggerNameIsEmptyErrorOnEmptyNameTextField() {
        let sut = RegisterViewModel()
        
        do {
            try sut.register()
            XCTFail("Register should fail with empty name")
        } catch {
            XCTAssertEqual(error as? RegisterViewModel.RegistrationError, .emptyName)
        }
    }

}
