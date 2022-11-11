//
//  RegisterViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 11.11.2022.
//

import XCTest
import Combine

class RegisterViewModel {
    
    var name = ""
    
    enum RegistrationError: Error {
        case emptyName
        case emptyEmail
    }
    
    func register() throws {
        if name.isEmpty {
            throw RegistrationError.emptyName
        }
        
        throw RegistrationError.emptyEmail
    }
    
}

final class RegisterViewModelTests: XCTestCase {

    func test_register_triggerEmptyNameErrorOnEmptyNameTextField() {
        let sut = RegisterViewModel()
        
        do {
            try sut.register()
            XCTFail("Register should fail with empty name")
        } catch {
            XCTAssertEqual(error as? RegisterViewModel.RegistrationError, .emptyName)
        }
    }
    
    func test_register_triggerEmptyEmailErrorOnEmptyEmailTextField() {
        let sut = RegisterViewModel()
        sut.name = "any name"
        
        do {
            try sut.register()
            XCTFail("Register should fail with empty email")
        } catch {
            XCTAssertEqual(error as? RegisterViewModel.RegistrationError, .emptyEmail)
        }
    }

}
