//
//  EditProfileViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import XCTest
import Foodybite
import Domain

final class EditProfileViewModelTests: XCTestCase {
    
    func test_isLoading_isTrueOnlyWhenResultIsLoading() {
        let (sut, _) = makeSUT()

        sut.state = .idle
        XCTAssertFalse(sut.isLoading)
        
        sut.state = .isLoading
        XCTAssertTrue(sut.isLoading)
        
        sut.state = .failure(.serverError)
        XCTAssertFalse(sut.isLoading)
        
        sut.state = .success
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_updateAccount_triggerEmptyNameErrorOnEmptyNameTextField() async {
        let (sut, _) = makeSUT()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.emptyName))
    }
    
    func test_updateAccount_triggerEmptyEmailErrorOnEmptyEmailTextField() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.emptyEmail))
    }
    
    func test_updateAccount_triggerInvalidFormatErrorOnInvalidEmail() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = invalidEmail()
        
        await assertRegister(on: sut, withExpectedResult: .failure(.invalidEmail))
    }
    
    func test_updateAccount_sendsValidInputsToAccountService() async {
        let (sut, accountServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        
        await sut.updateAccount()
        
        XCTAssertEqual(accountServiceSpy.capturedValues.map(\.name), [validName()])
        XCTAssertEqual(accountServiceSpy.capturedValues.map(\.email), [validEmail()])
        
        await sut.updateAccount()
        
        XCTAssertEqual(accountServiceSpy.capturedValues.map(\.name), [validName(), validName()])
        XCTAssertEqual(accountServiceSpy.capturedValues.map(\.email), [validEmail(), validEmail()])
    }
    
    func test_updateAccount_throwsErrorWhenAccountServiceThrowsError() async {
        let (sut, signUpServiceSpy) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        
        let expectedError = anyNSError()
        signUpServiceSpy.errorToThrow = expectedError
        
        await assertRegister(on: sut, withExpectedResult: .failure(.serverError))
    }
    
    func test_updateAccount_setsSuccessfulResultWhenAccountServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        sut.name = validName()
        sut.email = validEmail()
        
        await assertRegister(on: sut, withExpectedResult: .success)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: EditProfileViewModel, accountServiceSpy: AccountServiceSpy) {
        let accountServiceSpy = AccountServiceSpy()
        let sut = EditProfileViewModel(accountService: accountServiceSpy)
        return (sut, accountServiceSpy)
    }
    
    private func assertRegister(on sut: EditProfileViewModel,
                                withExpectedResult expectedResult: EditProfileViewModel.State,
                                file: StaticString = #file,
                                line: UInt = #line) async {
        let resultSpy = PublisherSpy(sut.$state.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [.idle], file: file, line: line)
        
        await sut.updateAccount()
        
        XCTAssertEqual(resultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
        resultSpy.cancel()
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
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
    
    private class AccountServiceSpy: AccountService {
        var errorToThrow: Error?
        private(set) var capturedValues = [(name: String, email: String, profileImage: Data?)]()
        
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {
            capturedValues.append((name, email, profileImage))
            
            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }
        
        func deleteAccount() async throws {
            
        }
    }

}
