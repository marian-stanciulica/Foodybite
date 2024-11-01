//
//  RegisterViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 11.11.2022.
//

import XCTest
import Domain
import FoodybitePresentation

final class RegisterViewModelTests: XCTestCase {

    func test_state_initiallyIdle() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.registerResult, .idle)
    }

    func test_isLoading_isTrueOnlyWhenRegisterResultIsLoading() {
        let (sut, _) = makeSUT()

        sut.registerResult = .idle
        XCTAssertFalse(sut.isLoading)

        sut.registerResult = .isLoading
        XCTAssertTrue(sut.isLoading)

        sut.registerResult = .failure(.serverError)
        XCTAssertFalse(sut.isLoading)

        sut.registerResult = .success
        XCTAssertFalse(sut.isLoading)
    }

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

    func test_register_triggerTooShortPasswordErrorOnTooShortPassword() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = shortPassword()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.tooShortPassword)))
    }

    func test_register_triggerPasswordDoesntContainUpperLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutUpperLetter()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainUpperLetter)))
    }

    func test_register_triggerPasswordDoesntContainLowerLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutLowerLetter()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainLowerLetter)))
    }

    func test_register_triggerPasswordDoesntContainDigits() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutDigits()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainDigits)))
    }

    func test_register_triggerPasswordDoesntContainSpecialCharacter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutSpecialCharacters()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))
    }

    func test_register_triggerPasswordsDontMatch() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordsDontMatch)))
    }

    func test_register_sendsValidInputsToSignUpService() async {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()
        sut.profileImage = anyData()

        await sut.register()

        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.name), [validName()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.email), [validEmail()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.password), [validPassword()])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.profileImage), [anyData()])
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

    func test_register_resetsInputsWhenSignUpServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()

        await sut.register()

        XCTAssertTrue(sut.name.isEmpty)
        XCTAssertTrue(sut.email.isEmpty)
        XCTAssertTrue(sut.password.isEmpty)
        XCTAssertTrue(sut.confirmPassword.isEmpty)
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

    private func shortPassword() -> String {
        "Aa1%"
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

    private func anyData() -> Data? {
        "any data".data(using: .utf8)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }

    private func assertRegister(on sut: RegisterViewModel,
                                withExpectedResult expectedResult: RegisterViewModel.State,
                                file: StaticString = #file,
                                line: UInt = #line) async {
        let registerResultSpy = PublisherSpy(sut.$registerResult.eraseToAnyPublisher())

        XCTAssertEqual(registerResultSpy.results, [.idle], file: file, line: line)

        await sut.register()

        XCTAssertEqual(registerResultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
        registerResultSpy.cancel()
    }

    private class SignUpServiceSpy: SignUpService {
        var errorToThrow: Error?
        private(set) var capturedValues = [(name: String, email: String, password: String, profileImage: Data?)]()

        func signUp(name: String, email: String, password: String, profileImage: Data?) async throws {
            capturedValues.append((name, email, password, profileImage))

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }
    }

}
