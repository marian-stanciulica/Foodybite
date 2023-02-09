//
//  ProfileViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import XCTest
import Foodybite
import Domain

final class ProfileViewModelTests: XCTestCase {

    func test_init_getReviewsStateIsIdle() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.getReviewsState, .idle)
    }
    
    func test_deleteAccount_setsErrorWhenAccountServiceThrowsError() async {
        let (sut, accountServiceSpy, _) = makeSUT()
        
        let expectedError = anyNSError()
        accountServiceSpy.errorToThrow = expectedError
        
        await assertDeleteAccount(on: sut, withExpectedResult: .accountDeletionError)
    }
    
    func test_deleteAccount_setsSuccessfulResultWhenAccountServiceReturnsSuccess() async {
        var goToLoginCalled = false
        let (sut, _, _) = makeSUT() {
            goToLoginCalled = true
        }
        
        await sut.deleteAccount()
        
        XCTAssertTrue(goToLoginCalled)
    }
    
    func test_getAllReviews_sendsNilPlaceIdToGetReviewsService() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT()
        
        await sut.getAllReviews()
        
        XCTAssertEqual(getReviewsServiceSpy.capturedValues.count, 1)
        XCTAssertNil(getReviewsServiceSpy.capturedValues[0])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(goToLogin: @escaping () -> Void = {}) -> (sut: ProfileViewModel, accountServiceSpy: AccountServiceSpy, getReviewsServiceSpy: GetReviewsServiceSpy) {
        let accountServiceSpy = AccountServiceSpy()
        let getReviewsServiceSpy = GetReviewsServiceSpy()
        let sut = ProfileViewModel(accountService: accountServiceSpy,
                                   getReviewsService: getReviewsServiceSpy,
                                   user: anyUser(),
                                   goToLogin: goToLogin)
        return (sut, accountServiceSpy, getReviewsServiceSpy)
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 1)
    }
    
    private func anyUser() -> User {
        User(id: UUID(), name: "User", email: "user@test.com", profileImage: nil)
    }
    
    private func assertDeleteAccount(on sut: ProfileViewModel,
                                     withExpectedResult expectedResult: ProfileViewModel.Error,
                                     file: StaticString = #file,
                                     line: UInt = #line) async {
        let resultSpy = PublisherSpy(sut.$error.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [nil], file: file, line: line)
        
        await sut.deleteAccount()
        
        XCTAssertEqual(resultSpy.results, [nil, expectedResult], file: file, line: line)
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
    
    private class GetReviewsServiceSpy: GetReviewsService {
        private(set) var capturedValues = [String?]()
        
        func getReviews(placeID: String?) async throws -> [Review] {
            capturedValues.append(placeID)
            return []
        }
    }
}
