//
//  RegisterViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 11.11.2022.
//

import Testing
import Foundation.NSData
import Domain
import FoodybitePresentation

struct RegisterViewModelTests {

    @Test func state_initiallyIdle() {
        let (sut, _) = makeSUT()

        #expect(sut.registerResult == .idle)
    }

    @Test func isLoading_isTrueOnlyWhenRegisterResultIsLoading() {
        let (sut, _) = makeSUT()

        sut.registerResult = .idle
        #expect(!sut.isLoading)

        sut.registerResult = .isLoading
        #expect(sut.isLoading)

        sut.registerResult = .failure(.serverError)
        #expect(!sut.isLoading)

        sut.registerResult = .success
        #expect(!sut.isLoading)
    }

    @Test func register_triggerEmptyNameErrorOnEmptyNameTextField() async {
        let (sut, _) = makeSUT()

        await assertRegister(on: sut, withExpectedResult: .failure(.emptyName))
    }

    @Test func register_triggerEmptyEmailErrorOnEmptyEmailTextField() async {
        let (sut, _) = makeSUT()
        sut.name = validName()

        await assertRegister(on: sut, withExpectedResult: .failure(.emptyEmail))
    }

    @Test func register_triggerInvalidFormatErrorOnInvalidEmail() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = invalidEmail()

        await assertRegister(on: sut, withExpectedResult: .failure(.invalidEmail))
    }

    @Test func register_triggerTooShortPasswordErrorOnTooShortPassword() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = shortPassword()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.tooShortPassword)))
    }

    @Test func register_triggerPasswordDoesntContainUpperLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutUpperLetter()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainUpperLetter)))
    }

    @Test func register_triggerPasswordDoesntContainLowerLetter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutLowerLetter()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainLowerLetter)))
    }

    @Test func register_triggerPasswordDoesntContainDigits() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutDigits()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainDigits)))
    }

    @Test func register_triggerPasswordDoesntContainSpecialCharacter() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = passwordWithoutSpecialCharacters()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))
    }

    @Test func register_triggerPasswordsDontMatch() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordsDontMatch)))
    }

    @Test func register_sendsValidInputsToSignUpService() async {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()
        sut.profileImage = anyData()

        await sut.register()

        #expect(signUpServiceSpy.capturedValues.map(\.name) == [validName()])
        #expect(signUpServiceSpy.capturedValues.map(\.email) == [validEmail()])
        #expect(signUpServiceSpy.capturedValues.map(\.password) == [validPassword()])
        #expect(signUpServiceSpy.capturedValues.map(\.profileImage) == [anyData()])
    }

    @Test func register_throwsErrorWhenSignUpServiceThrowsError() async {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()

        let expectedError = anyNSError()
        signUpServiceSpy.errorToThrow = expectedError

        await assertRegister(on: sut, withExpectedResult: .failure(.serverError))
    }

    @Test func register_setsSuccessfulResultWhenSignUpServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()

        await assertRegister(on: sut, withExpectedResult: .success)
    }

    @Test func register_resetsInputsWhenSignUpServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        sut.password = validPassword()
        sut.confirmPassword = validPassword()

        await sut.register()

        #expect(sut.name.isEmpty)
        #expect(sut.email.isEmpty)
        #expect(sut.password.isEmpty)
        #expect(sut.confirmPassword.isEmpty)
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
                                sourceLocation: SourceLocation = #_sourceLocation) async {
        let registerResultSpy = PublisherSpy(sut.$registerResult.eraseToAnyPublisher())

        #expect(registerResultSpy.results == [.idle], sourceLocation: sourceLocation)

        await sut.register()

        #expect(registerResultSpy.results == [.idle, .isLoading, expectedResult], sourceLocation: sourceLocation)
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
