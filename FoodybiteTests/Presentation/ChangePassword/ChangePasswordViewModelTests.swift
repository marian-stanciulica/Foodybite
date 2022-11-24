//
//  ChangePasswordViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 24.11.2022.
//

import XCTest
import Foodybite
import FoodybiteNetworking

final class ChangePasswordViewModelTests: XCTestCase {

    func test_changePassword_triggerEmptyPasswordErrorOnEmptyCurrentPassword() async {
        let (sut, _) = makeSUT()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.empty))
    }
    
    func test_changePassword_triggerTooShortPasswordErrorOnTooShortNewPassword() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = shortPassword()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.tooShortPassword))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainUpperLetter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutUpperLetter()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainUpperLetter))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainLowerLetter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutLowerLetter()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainLowerLetter))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainDigits() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutDigits()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainDigits))
    }
    
    func test_changePassword_triggerNewPasswordDoesntContainSpecialCharacter() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = passwordWithoutSpecialCharacters()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordDoesntContainSpecialCharacter))
    }
    
    func test_changePassword_triggerNewAndConfirmPasswordsDontMatch() async {
        let (sut, _) = makeSUT()
        sut.currentPassword = nonEmptyPassword()
        sut.newPassword = validPassword()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.passwordsDontMatch))
    }
    
    func test_changePassword_sendsValidInputsToChangePasswordService() async {
        let (sut, signUpServiceSpy) = makeSUT()
        let firstCurrentPassword = validPassword()
        let firstNewPassword = validPassword()
        
        sut.currentPassword = firstCurrentPassword
        sut.newPassword = firstNewPassword
        sut.confirmPassword = firstNewPassword
        
        await sut.changePassword()
        
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.currentPassword), [firstCurrentPassword])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.newPassword), [firstNewPassword])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.confirmPassword), [firstNewPassword])
        
        let secondCurrentPassword = validPassword()
        let secondNewPassword = validPassword()
        
        sut.currentPassword = secondCurrentPassword
        sut.newPassword = secondNewPassword
        sut.confirmPassword = secondNewPassword
        
        await sut.changePassword()
        
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.currentPassword), [firstCurrentPassword, secondCurrentPassword])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.newPassword), [firstNewPassword, secondNewPassword])
        XCTAssertEqual(signUpServiceSpy.capturedValues.map(\.confirmPassword), [firstNewPassword, secondNewPassword])
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ChangePasswordViewModel, changePasswordService: ChangePasswordServiceSpy) {
        let changePasswordService = ChangePasswordServiceSpy()
        let sut = ChangePasswordViewModel(changePasswordService: changePasswordService)
        return (sut, changePasswordService)
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
    
    private func assertRegister(on sut: ChangePasswordViewModel,
                                withExpectedResult expectedResult: ChangePasswordViewModel.Result,
                                file: StaticString = #file,
                                line: UInt = #line) async {
        let registerResultSpy = PublisherSpy(sut.$result.eraseToAnyPublisher())

        XCTAssertEqual(registerResultSpy.results, [.notTriggered], file: file, line: line)
        
        await sut.changePassword()
        
        XCTAssertEqual(registerResultSpy.results, [.notTriggered, expectedResult], file: file, line: line)
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
