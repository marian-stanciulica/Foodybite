//
//  ProfileViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 25.11.2022.
//

import Testing
import Foundation.NSURL
import Foundation.NSData
import Domain
import FoodybitePresentation

struct ProfileViewModelTests {

    @Test func init_getReviewsStateIsIdle() {
        let (sut, _, _) = makeSUT()

        #expect(sut.getReviewsState == .idle)
    }

    @Test func deleteAccount_setsErrorWhenAccountServiceThrowsError() async {
        let (sut, accountServiceSpy, _) = makeSUT()

        let expectedError = anyNSError()
        accountServiceSpy.errorToThrow = expectedError

        await assertDeleteAccount(on: sut, withExpectedResult: .serverError)
    }

    @Test func deleteAccount_setsSuccessfulResultWhenAccountServiceReturnsSuccess() async {
        var goToLoginCalled = false
        let (sut, _, _) = makeSUT {
            goToLoginCalled = true
        }

        await sut.deleteAccount()

        #expect(goToLoginCalled)
    }

    @Test func getAllReviews_sendsNilRestaurantIDToGetReviewsService() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT()

        await sut.getAllReviews()

        #expect(getReviewsServiceSpy.capturedValues.count == 1)
        #expect(getReviewsServiceSpy.capturedValues[0] == nil)
    }

    @Test func getAllReviews_setsStateToLoadingErrorWhenGetReviewsServiceThrowsError() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT()
        getReviewsServiceSpy.result = .failure(anyNSError())
        let stateSpy = PublisherSpy(sut.$getReviewsState.eraseToAnyPublisher())

        await sut.getAllReviews()

        #expect(stateSpy.results == [.idle, .isLoading, .failure(.serverError)])
    }

    @Test func getAllReviews_setsStateToRequestSucceededWhenGetReviewsServiceReturnsSuccess() async {
        let (sut, _, getReviewsServiceSpy) = makeSUT()
        let expectedReviews = anyReviews()
        getReviewsServiceSpy.result = .success(expectedReviews)
        let stateSpy = PublisherSpy(sut.$getReviewsState.eraseToAnyPublisher())

        await sut.getAllReviews()

        #expect(stateSpy.results == [.idle, .isLoading, .success(expectedReviews)])
    }

    // MARK: - Helpers

    private func makeSUT(goToLogin: @escaping () -> Void = {}) -> (
        sut: ProfileViewModel,
        accountServiceSpy: AccountServiceSpy,
        getReviewsServiceSpy: GetReviewsServiceSpy
    ) {
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
            Review(
                restaurantID: "restaurant #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author #1",
                reviewText: "It was nice",
                rating: 4,
                relativeTime: "1 hour ago"
            ),
            Review(
                restaurantID: "restaurant #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: "Author #2",
                reviewText: "Didn't like it",
                rating: 1,
                relativeTime: "2 years ago"
            )
        ]
    }

    private func assertDeleteAccount(on sut: ProfileViewModel,
                                     withExpectedResult expectedResult: ProfileViewModel.DeleteAccountError,
                                     sourceLocation: SourceLocation = #_sourceLocation) async {
        let resultSpy = PublisherSpy(sut.$deleteAccountError.eraseToAnyPublisher())

        #expect(resultSpy.results == [nil], sourceLocation: sourceLocation)

        await sut.deleteAccount()

        #expect(resultSpy.results == [nil, expectedResult], sourceLocation: sourceLocation)
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

        func getReviews(restaurantID: String?) async throws -> [Review] {
            capturedValues.append(restaurantID)

            if let result = result {
                return try result.get()
            }

            return []
        }
    }
}
