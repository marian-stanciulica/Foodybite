//
//  ChangePasswordViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import Testing
import Foundation.NSError
import Domain
import FoodybitePresentation

struct ChangePasswordViewModelTests {

    @Test func init_variablesInitialValues() {
        let (sut, _) = makeSUT()

        #expect(sut.currentPassword.isEmpty)
        #expect(sut.newPassword.isEmpty)
        #expect(sut.confirmPassword.isEmpty)
        #expect(sut.result == .idle)
    }

    @Test func isLoading_isTrueOnlyWhenResultIsLoading() {
        let (sut, _) = makeSUT()

        sut.result = .idle
        #expect(!sut.isLoading)

        sut.result = .isLoading
        #expect(sut.isLoading)

        sut.result = .failure(.serverError)
        #expect(!sut.isLoading)

        sut.result = .success
        #expect(!sut.isLoading)
    }

    @Test func changePassword_triggerEmptyPasswordErrorOnEmptyCurrentPassword() async {
        let (sut, _) = makeSUT()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.empty)))
    }

    @Test func changePassword_triggerTooShortPasswordErrorOnTooShortNewPassword() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = shortPassword()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.tooShortPassword)))
    }

    @Test func changePassword_triggerNewPasswordDoesntContainUpperLetter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutUpperLetter()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainUpperLetter)))
    }

    @Test func changePassword_triggerNewPasswordDoesntContainLowerLetter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutLowerLetter()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainLowerLetter)))
    }

    @Test func changePassword_triggerNewPasswordDoesntContainDigits() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutDigits()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainDigits)))
    }

    @Test func changePassword_triggerNewPasswordDoesntContainSpecialCharacter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutSpecialCharacters()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))
    }

    @Test func changePassword_triggerNewAndConfirmPasswordsDontMatch() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = validPassword()

        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordsDontMatch)))
    }

    @Test func changePassword_sendsValidInputsToChangePasswordService() async {
        let (sut, serviceSpy) = makeSUT()
        let firstCurrentPassword = validPassword()
        let firstNewPassword = validPassword()

        sut.currentPassword = firstCurrentPassword
        sut.newPassword = firstNewPassword
        sut.confirmPassword = firstNewPassword

        await sut.changePassword()

        #expect(serviceSpy.capturedValues.map(\.currentPassword) == [firstCurrentPassword])
        #expect(serviceSpy.capturedValues.map(\.newPassword) == [firstNewPassword])

        let secondCurrentPassword = validPassword()
        let secondNewPassword = validPassword()

        sut.currentPassword = secondCurrentPassword
        sut.newPassword = secondNewPassword
        sut.confirmPassword = secondNewPassword

        await sut.changePassword()

        #expect(serviceSpy.capturedValues.map(\.currentPassword) == [firstCurrentPassword, secondCurrentPassword])
        #expect(serviceSpy.capturedValues.map(\.newPassword) == [firstNewPassword, secondNewPassword])
    }

    @Test func changePassword_throwsErrorWhenChangePasswordServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        sut.currentPassword = validPassword()
        sut.newPassword = validPassword()
        sut.confirmPassword = sut.newPassword

        let expectedError = anyNSError()
        serviceSpy.errorToThrow = expectedError

        await assertRegister(on: sut, withExpectedResult: .failure(.serverError))
    }

    @Test func changePassword_setsSuccessfulResultWhenChangePasswordServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = validPassword()
        sut.newPassword = validPassword()
        sut.confirmPassword = sut.newPassword

        await assertRegister(on: sut, withExpectedResult: .success)
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: ChangePasswordViewModel, serviceSpy: ChangePasswordServiceSpy) {
        let serviceSpy = ChangePasswordServiceSpy()
        let sut = ChangePasswordViewModel(changePasswordService: serviceSpy)
        return (sut, serviceSpy)
    }

    private func nonEmptyPassword() -> String {
        "non empty"
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
        "ABCabc123%" + randomString(size: 20)
    }

    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }

    private func assertRegister(on sut: ChangePasswordViewModel,
                                withExpectedResult expectedResult: ChangePasswordViewModel.Result,
                                sourceLocation: SourceLocation = #_sourceLocation) async {
        let registerResultSpy = PublisherSpy(sut.$result.eraseToAnyPublisher())

        #expect(registerResultSpy.results == [.idle], sourceLocation: sourceLocation)

        await sut.changePassword()

        #expect(registerResultSpy.results == [.idle, .isLoading, expectedResult], sourceLocation: sourceLocation)
        registerResultSpy.cancel()
    }

    private class ChangePasswordServiceSpy: ChangePasswordService {
        var errorToThrow: Error?
        private(set) var capturedValues = [(currentPassword: String, newPassword: String)]()

        func changePassword(currentPassword: String, newPassword: String) async throws {
            capturedValues.append((currentPassword, newPassword))

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }
    }

}
