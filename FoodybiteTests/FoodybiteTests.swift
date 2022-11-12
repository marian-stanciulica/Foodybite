//
//  RegisterViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 11.11.2022.
//

import XCTest
import Combine
import FoodybiteNetworking

class RegisterViewModel {
    private let signUpService: SignUpService
    
    var name = ""
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    enum RegistrationError: Error {
        case emptyName
        case emptyEmail
        case invalidEmail
        case emptyPassword
        case passwordDoesntContainUpperLetter
        case passwordDoesntContainLowerLetter
        case passwordDoesntContainDigits
        case passwordDoesntContainSpecialCharacter
        case passwordsDontMatch
    }
    
    init(apiService: SignUpService) {
        self.signUpService = apiService
    }
    
    func register() async throws {
        if name.isEmpty {
            throw RegistrationError.emptyName
        }
        
        if email.isEmpty {
            throw RegistrationError.emptyEmail
        } else if !isValid(email: email) {
            throw RegistrationError.invalidEmail
        }
        
        if password.isEmpty {
            throw RegistrationError.emptyPassword
        } else if !containsUpperLetter(password: password) {
            throw RegistrationError.passwordDoesntContainUpperLetter
        } else if !containsLowerLetter(password: password) {
            throw RegistrationError.passwordDoesntContainLowerLetter
        } else if !containsDigits(password: password) {
            throw RegistrationError.passwordDoesntContainDigits
        } else if !containsSpecialCharacters(password: password) {
            throw RegistrationError.passwordDoesntContainSpecialCharacter
        }
        
        if password != confirmPassword {
            throw RegistrationError.passwordsDontMatch
        }
        
        try await signUpService.signUp(name: name,
                                       email: email,
                                       password: password,
                                       confirmPassword: confirmPassword)
     }
    
    private func isValid(email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    private func containsUpperLetter(password: String) -> Bool {
        let regex = ".*[A-Z]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func containsLowerLetter(password: String) -> Bool {
        let regex = ".*[a-z]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func containsDigits(password: String) -> Bool {
        let regex = ".*[0-9]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    private func containsSpecialCharacters(password: String) -> Bool {
        let regex = ".*[.*&^%$#@()/]+.*"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
}

final class RegisterViewModelTests: XCTestCase {

    func test_register_triggerEmptyNameErrorOnEmptyNameTextField() async {
        let (sut, _) = makeSUT()
        
        await assertRegister(on: sut, withExpectedError: .emptyName)
    }
    
    func test_register_triggerEmptyEmailErrorOnEmptyEmailTextField() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        
        await assertRegister(on: sut, withExpectedError: .emptyEmail)
    }
    
    func test_register_triggerInvalidFormatErrorOnInvalidEmail() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = invalidEmail()
        
        await assertRegister(on: sut, withExpectedError: .invalidEmail)
    }
    
    func test_register_triggerEmptyPasswordErrorOnEmptyPassword() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        
        await assertRegister(on: sut, withExpectedError: .emptyPassword)
    }
    
    func test_register_triggerPasswordDoesntContainUpperLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutUpperLetter()
        
        await assertRegister(on: sut, withExpectedError: .passwordDoesntContainUpperLetter)
    }
    
    func test_register_triggerPasswordDoesntContainLowerLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutLowerLetter()
        
        await assertRegister(on: sut, withExpectedError: .passwordDoesntContainLowerLetter)
    }
    
    func test_register_triggerPasswordDoesntContainDigits() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutDigits()
        
        await assertRegister(on: sut, withExpectedError: .passwordDoesntContainDigits)
    }
    
    func test_register_triggerPasswordDoesntContainSpecialCharacter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutSpecialCharacters()
        
        await assertRegister(on: sut, withExpectedError: .passwordDoesntContainSpecialCharacter)
    }
    
    func test_register_triggerPasswordsDontMatch() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        
        await assertRegister(on: sut, withExpectedError: .passwordsDontMatch)
    }
    
    func test_register_sendsValidInputsToSignUpService() async throws {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()
        
        try await sut.register()
        
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.name), [validName()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.email), [validEmail()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.password), [validPassword()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.confirmPassword), [validPassword()])
        
        try await sut.register()
        
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.name), [validName(), validName()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.email), [validEmail(), validEmail()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.password), [validPassword(), validPassword()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.confirmPassword), [validPassword(), validPassword()])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RegisterViewModel, apiService: SignUpServiceSpy) {
        let signUpServiceSpy = SignUpServiceSpy()
        let sut = RegisterViewModel(apiService: signUpServiceSpy)
        return (sut, signUpServiceSpy)
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
    
    private func passwordWithoutUpperLetter() -> String {
        "abc123%"
    }
    
    private func passwordWithoutLowerLetter() -> String {
        "ABC123%"
    }
    
    private func passwordWithoutDigits() -> String {
        "ABCabc%"
    }
    
    private func passwordWithoutSpecialCharacters() -> String {
        "ABCabc123"
    }
    
    private func validPassword() -> String {
        "ABCabc123%"
    }
    
    private func assertRegister(on sut: RegisterViewModel,
                                withExpectedError expectedError: RegisterViewModel.RegistrationError,
                                file: StaticString = #file,
                                line: UInt = #line) async {
        do {
            try await sut.register()
            XCTFail("Register should fail with \(expectedError)", file: file, line: line)
        } catch {
            XCTAssertEqual(error as? RegisterViewModel.RegistrationError, expectedError, file: file, line: line)
        }
    }
    
    private class SignUpServiceSpy: SignUpService {
        private(set) var capturedValues = [(name: String, email: String, password: String, confirmPassword: String)]()
        
        func signUp(name: String, email: String, password: String, confirmPassword: String) async throws {
            capturedValues.append((name, email, password, confirmPassword))
        }
    }

}
