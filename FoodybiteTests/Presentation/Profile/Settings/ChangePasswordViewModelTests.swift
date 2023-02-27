//
//  ChangePasswordViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import XCTest
import Foodybite
import Domain

final class ChangePasswordViewModelTests: XCTestCase {

    func test_changePassword_triggerEmptyPasswordErrorOnEmptyCurrentPassword() async {
        let (sut, _) = makeSUT()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.empty)))
    }
    
    func test_changePassword_triggerTooShortPasswordErrorOnTooShortNewPassword() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = shortPassword()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.tooShortPassword)))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainUpperLetter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutUpperLetter()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainUpperLetter)))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainLowerLetter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutLowerLetter()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainLowerLetter)))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainDigits() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutDigits()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainDigits)))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainSpecialCharacter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutSpecialCharacters()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordDoesntContainSpecialCharacter)))
    }
    
    func test_changePassword_triggerNewAndConfirmPasswordsDontMatch() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = validPassword()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordError(.passwordsDontMatch)))
    }
    
    func test_changePassword_sendsValidInputsToChangePasswordService() async {
        let (sut, serviceSpy) = makeSUT()
        let firstCurrentPassword = validPassword()
        let firstNewPassword = validPassword()
        
        sut.currentPassword = firstCurrentPassword
        sut.newPassword = firstNewPassword
        sut.confirmPassword = firstNewPassword
        
        await sut.changePassword()
        
        XCTAssertEqual(serviceSpy.capturedValues.map(\.currentPassword), [firstCurrentPassword])
        XCTAssertEqual(serviceSpy.capturedValues.map(\.newPassword), [firstNewPassword])
        XCTAssertEqual(serviceSpy.capturedValues.map(\.confirmPassword), [firstNewPassword])
        
        let secondCurrentPassword = validPassword()
        let secondNewPassword = validPassword()
        
        sut.currentPassword = secondCurrentPassword
        sut.newPassword = secondNewPassword
        sut.confirmPassword = secondNewPassword
        
        await sut.changePassword()
        
        XCTAssertEqual(serviceSpy.capturedValues.map(\.currentPassword), [firstCurrentPassword, secondCurrentPassword])
        XCTAssertEqual(serviceSpy.capturedValues.map(\.newPassword), [firstNewPassword, secondNewPassword])
        XCTAssertEqual(serviceSpy.capturedValues.map(\.confirmPassword), [firstNewPassword, secondNewPassword])
    }
    
    func test_changePassword_throwsErrorWhenChangePasswordServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        sut.currentPassword = validPassword()
        sut.newPassword = validPassword()
        sut.confirmPassword = sut.newPassword
        
        let expectedError = anyNSError()
        serviceSpy.errorToThrow = expectedError
        
        await assertRegister(on: sut, withExpectedResult: .failure(.serverError))
    }
    
    func test_changePassword_setsSuccessfulResultWhenChangePasswordServiceReturnsSuccess() async {
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
                                file: StaticString = #file,
                                line: UInt = #line) async {
        let registerResultSpy = PublisherSpy(sut.$result.eraseToAnyPublisher())

        XCTAssertEqual(registerResultSpy.results, [.idle], file: file, line: line)
        
        await sut.changePassword()
        
        XCTAssertEqual(registerResultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
        registerResultSpy.cancel()
    }
    
    private class ChangePasswordServiceSpy: ChangePasswordService {
        var errorToThrow: Error?
        private(set) var capturedValues = [(currentPassword: String, newPassword: String, confirmPassword: String)]()
        
        func changePassword(currentPassword: String, newPassword: String, confirmPassword: String) async throws {
            capturedValues.append((currentPassword, newPassword, confirmPassword))
            
            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }
    }

}
