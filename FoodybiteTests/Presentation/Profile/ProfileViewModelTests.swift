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
        
        XCTAssertEqual(sut.getReviewsState, .isLoading)
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
    
    func test_getAllReviews_setsStateToLoadingErrorWhenGetReviewsServiceThrowsError() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT()
        getReviewsServiceSpy.result = .failure(anyNSError())
        let stateSpy = PublisherSpy(sut.$getReviewsState.eraseToAnyPublisher())
        
        await sut.getAllReviews()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .loadingError("An error occured while fetching reviews. Please try again later!")])
    }
    
    func test_getAllReviews_setsStateToRequestSucceededWhenGetReviewsServiceReturnsSuccess() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT()
        let expectedReviews = anyReviews()
        getReviewsServiceSpy.result = .success(expectedReviews)
        let stateSpy = PublisherSpy(sut.$getReviewsState.eraseToAnyPublisher())

        await sut.getAllReviews()
        
        XCTAssertEqual(stateSpy.results, [.isLoading, .requestSucceeeded(expectedReviews)])
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
    
    private func anyReviews() -> [Review] {
        [
            Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Author #1", reviewText: "It was nice", rating: 4, relativeTime: "1 hour ago"),
            Review(placeID: "place #1", profileImageURL: nil, profileImageData: nil, authorName: "Author #2", reviewText: "Didn't like it", rating: 1, relativeTime: "2 years ago")
        ]
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
        var result: Result<[Review], Error>?
        
        func getReviews(placeID: String?) async throws -> [Review] {
            capturedValues.append(placeID)
            
            if let result = result {
                return try result.get()
            }
            
            return []
        }
    }
}
