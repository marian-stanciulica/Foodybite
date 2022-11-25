//
//  ProfileViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import XCTest
import Foodybite
import FoodybiteNetworking

final class ProfileViewModelTests: XCTestCase {

    func test_deleteAccount_throwsErrorWhenAccountServiceThrowsError() async {
        let (sut, accountServiceSpy) = makeSUT()
        
        let expectedError = anyNSError()
        accountServiceSpy.errorToThrow = expectedError
        
        await assertDeleteAccount(on: sut, withExpectedResult: .failure(.serverError))
    }
    
    func test_deleteAccount_setsSuccessfulResultWhenAccountServiceReturnsSuccess() async {
        let (sut, _) = makeSUT()
        
        await assertDeleteAccount(on: sut, withExpectedResult: .success)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: ProfileViewModel, accountServiceSpy: AccountServiceSpy) {
        let accountServiceSpy = AccountServiceSpy()
        let sut = ProfileViewModel(accountService: accountServiceSpy)
        return (sut, accountServiceSpy)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
    
    private func assertDeleteAccount(on sut: ProfileViewModel,
                                     withExpectedResult expectedResult: ProfileViewModel.Result,
                                     file: StaticString = #file,
                                     line: UInt = #line) async {
        let resultSpy = PublisherSpy(sut.$result.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [.notTriggered], file: file, line: line)
        
        await sut.deleteAccount()
        
        XCTAssertEqual(resultSpy.results, [.notTriggered, expectedResult], file: file, line: line)
        resultSpy.cancel()
    }
                               
    private class AccountServiceSpy: AccountService {
        var errorToThrow: Error?
        private(set) var deleteAccountCallCount = 0

        func deleteAccount() async throws {
            deleteAccountCallCount += 1

            if let errorToThrow = errorToThrow {
                throw errorToThrow
            }
        }
        
        func updateAccount(name: String, email: String, profileImage: Data?) async throws {}
    }
    
}
