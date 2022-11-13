//
//  RegisterViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 11.11.2022.
//

import XCTest
import Combine
import Foodybite
import FoodybiteNetworking

final class RegisterViewModelTests: XCTestCase {
    
    func test_register_triggerEmptyNameErrorOnEmptyNameTextField() async {
        let (sut, _) = makeSUT()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.emptyName))
    }
    
    func test_register_triggerEmptyEmailErrorOnEmptyEmailTextField() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.emptyEmail))
    }
    
    func test_register_triggerInvalidFormatErrorOnInvalidEmail() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = invalidEmail()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.invalidEmail))
    }
    
    func test_register_triggerEmptyPasswordErrorOnEmptyPassword() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.emptyPassword))
    }
    
    func test_register_triggerPasswordDoesntContainUpperLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutUpperLetter()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainUpperLetter))
    }
    
    func test_register_triggerPasswordDoesntContainLowerLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutLowerLetter()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainLowerLetter))
    }
    
    func test_register_triggerPasswordDoesntContainDigits() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutDigits()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainDigits))
    }
    
    func test_register_triggerPasswordDoesntContainSpecialCharacter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutSpecialCharacters()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainSpecialCharacter))
    }
    
    func test_register_triggerPasswordsDontMatch() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordsDontMatch))
    }
    
    func test_register_sendsValidInputsToSignUpService() async {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()
        
        await sut.register()
        
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.name), [validName()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.email), [validEmail()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.password), [validPassword()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.confirmPassword), [validPassword()])
        
        await sut.register()
        
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.name), [validName(), validName()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.email), [validEmail(), validEmail()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.password), [validPassword(), validPassword()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.confirmPassword), [validPassword(), validPassword()])
    }
    
    func test_register_throwsErrorWhenSignUpServiceThrowsError() async {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()
        
        let expectedError = anyNSError()
        signUpServiceSpy.errorToThrow = expectedError
        
        await assertRegister(on: sut, withExpectedResult: .failure(.serverError))
    }
    
    func test_register_setsSuccessfulResultWhenSignUpServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()
        
        await assertRegister(on: sut, withExpectedResult: .success)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RegisterViewModel, signUpService: SignUpServiceSpy) {
        let signUpServiceSpy = SignUpServiceSpy()
        let sut = RegisterViewModel(signUpService: signUpServiceSpy)
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
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
    
    private func assertRegister(on sut: RegisterViewModel,
                                withExpectedResult expectedResult: RegisterViewModel.RegisterResult,
                                file: StaticString = #file,
                                line: UInt = #line) async {
        let registerResultSpy = PublisherSpy(sut.$registerResult.eraseToAnyPublisher())

        XCTAssertEqual(registerResultSpy.results, [.notTriggered], file: file, line: line)
        
        await sut.register()
        
        XCTAssertEqual(registerResultSpy.results, [.notTriggered, expectedResult], file: file, line: line)
        registerResultSpy.cancel()
    }
    
    private class SignUpServiceSpy: SignUpService {
        var errorToThrow: Error?
        private(set) var capturedValues = [(name: String, email: String, password: String, confirmPassword: String)]()
        
        func signUp(name: String, email: String, password: String, confirmPassword: String) async throws {
            capturedValues.append((name, email, password, confirmPassword))
            
            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }
    }
    
    private class PublisherSpy<Success> where Success: Equatable {
        private var cancellable: Cancellable?
        private(set) var results = [Success]()
        
        init(_ publisher: AnyPublisher<Success, Never>) {
            cancellable = publisher.sink(receiveValue: { value in
                self.results.append(value)
            })
        }
        
        func cancel() {
            cancellable?.cancel()
        }
    }

}