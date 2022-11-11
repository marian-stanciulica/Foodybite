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
    var email = ""
    
    enum RegistrationError: Error {
        case emptyName
        case emptyEmail
        case invalidEmail
    }
    
    func register() throws {
        if name.isEmpty {
            throw RegistrationError.emptyName
        }
        
        if email.isEmpty {
            throw RegistrationError.emptyEmail
        } else if !isValid(email: email) {
            throw RegistrationError.invalidEmail
        }
    }
    
    private func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
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
    
    func test_register_triggerInvalidFormatErrorOnInvalidEmail() {
        let sut = RegisterViewModel()
        sut.name = "any name"
        sut.email = "invalid email"
        
        do {
            try sut.register()
            XCTFail("Register should fail with invalid email")
        } catch {
            XCTAssertEqual(error as? RegisterViewModel.RegistrationError, .invalidEmail)
        }
    }

}
