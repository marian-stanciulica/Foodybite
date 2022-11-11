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
        case emptyPassword
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
        
        throw RegistrationError.emptyPassword
    }
    
    private func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
}

final class RegisterViewModelTests: XCTestCase {

    func test_register_triggerEmptyNameErrorOnEmptyNameTextField() {
        let sut = makeSUT()
        
        assertRegister(on: sut, withExpectedError: .emptyName)
    }
    
    func test_register_triggerEmptyEmailErrorOnEmptyEmailTextField() {
        let sut = makeSUT()
        sut.name = validName()
        
        assertRegister(on: sut, withExpectedError: .emptyEmail)
    }
    
    func test_register_triggerInvalidFormatErrorOnInvalidEmail() {
        let sut = makeSUT()
        sut.name = validName()
        sut.email = invalidEmail()
        
        assertRegister(on: sut, withExpectedError: .invalidEmail)
    }
    
    func test_register_triggerEmptyPasswordErrorOnEmptyPassword() {
        let sut = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        
        assertRegister(on: sut, withExpectedError: .emptyPassword)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> RegisterViewModel {
        RegisterViewModel()
    }
    
    private func validName() -> String {
        "any name"
    }
    
    private func invalidEmail() -> String {
        "invalid email"
    }
    
    private func validEmail() -> String {
        "test@test.com"
    }
    
    private func assertRegister(on sut: RegisterViewModel,
                                withExpectedError expectedError: RegisterViewModel.RegistrationError,
                                file: StaticString = #file,
                                line: UInt = #line) {
        do {
            try sut.register()
            XCTFail("Register should fail with \(expectedError)", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? RegisterViewModel.RegistrationError, expectedError, file: file, line: line)
        }
    }

}
