//
//  FoodybiteNetworkingAPIEndToEndTests.swift
//  FoodybiteAPIEndToEndTests
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import Testing
import Foundation
import Domain
import API_Infra
import FoodybiteNetworking

struct FoodybiteNetworkingAPIEndToEndTests {

    @Test func endToEndSignUp_returnsSuccesfully() async {
        await execute(action: {
            try await makeSUT().signUp(name: testingName,
                                       email: testingEmail,
                                       password: testingPassword,
                                       profileImage: testingProfileImage)
        })
    }

    @Test func endToEndLogin_returnsExpectedUser() async {
        await executeLogin()
    }

    @Test func endToEndChangePassword_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().changePassword(currentPassword: testingPassword,
                                                            newPassword: testingNewPassword)
        })
    }

    @Test func endToEndLogout_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().logout()
        })
    }

    @Test func endToEndUpdateAccount_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().updateAccount(name: testingNewName,
                                                           email: testingEmail,
                                                           profileImage: testingNewProfileImage)
        })
    }

    @Test func endToEndAddReview_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().addReview(
                restaurantID: firstRestaurantID(),
                reviewText: firstReviewText(),
                starsNumber: firstStarsNumber(),
                createdAt: firstCreatedAt()
            )
        })
    }

    @Test func endToEndGetReviews_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().addReview(
                restaurantID: secondRestaurantID(),
                reviewText: secondReviewText(),
                starsNumber: secondStarsNumber(),
                createdAt: secondCreatedAt()
            )
        })

        await executeGetReviews(restaurantID: firstRestaurantID(), expectedReviews: expectedReviewsForFirstRestaurantID())
        await executeGetReviews(restaurantID: secondRestaurantID(), expectedReviews: expectedReviewsForSecondRestaurantID())
        await executeGetReviews(expectedReviews: expectedAllReviews())
    }

    @Test func endToEndDeleteAccount_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().deleteAccount()
        })
    }

    // MARK: - Helpers

    private func makeSUT() -> APIService {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let tokenStore = KeychainTokenStore()

        let remoteResourceLoader = RemoteStore(client: httpClient)
        return APIService(loader: remoteResourceLoader,
                          sender: remoteResourceLoader,
                          tokenStore: tokenStore)
    }

    private func makeAuthenticatedSUT() -> APIService {
        let session = URLSession(configuration: .ephemeral)
        let httpClient = URLSessionHTTPClient(session: session)
        let refreshTokenLoader = RemoteStore(client: httpClient)
        let tokenStore = KeychainTokenStore()

        let tokenRefresher = RefreshTokenService(loader: refreshTokenLoader, tokenStore: tokenStore)
        let authenticatedHTTPClient = AuthenticatedURLSessionHTTPClient(decoratee: httpClient, tokenRefresher: tokenRefresher)
        let authenticatedRemoteResourceLoader = RemoteStore(client: authenticatedHTTPClient)

        return APIService(loader: authenticatedRemoteResourceLoader,
                          sender: authenticatedRemoteResourceLoader,
                          tokenStore: tokenStore)
    }

    private func execute(action: () async throws -> Void, sourceLocation: SourceLocation = #_sourceLocation) async {
        do {
            try await action()
        } catch {
            Issue.record("Expected successful request, got \(error) instead", sourceLocation: sourceLocation)
        }
    }

    private func executeLogin(sourceLocation: SourceLocation = #_sourceLocation) async {
        do {
            let receivedUser = try await makeSUT().login(email: testingEmail, password: testingPassword)
            #expect(receivedUser.isEqual(to: expectedUser), sourceLocation: sourceLocation)
        } catch {
            Issue.record("Expected successful login request, got \(error) instead", sourceLocation: sourceLocation)
        }
    }

    private func executeGetReviews(
        restaurantID: String? = nil,
        expectedReviews: [Review],
        sourceLocation: SourceLocation = #_sourceLocation
    ) async {
        do {
            let receivedReviews = try await makeAuthenticatedSUT().getReviews(restaurantID: restaurantID)
            #expect(receivedReviews.isEqual(to: expectedReviews), sourceLocation: sourceLocation)
        } catch {
            Issue.record("Expected successful get reviews, got \(error) instead", sourceLocation: sourceLocation)
        }
    }

    private var testingName: String {
        "Testing"
    }

    private var testingNewName: String {
        "New testing name"
    }

    private var testingEmail: String {
        "testing@testing.com"
    }

    private var testingPassword: String {
        "123Password321$"
    }

    private var testingNewPassword: String {
        "new123Password321$"
    }

    private var testingProfileImage: Data? {
        "profile image".data(using: .utf8)
    }

    private var testingNewProfileImage: Data? {
        "new profile image".data(using: .utf8)
    }

    private var expectedUser: User {
        User(id: UUID(),
             name: testingName,
             email: testingEmail,
             profileImage: testingProfileImage)
    }

    private func firstRestaurantID() -> String {
        "first restaurant id"
    }

    private func secondRestaurantID() -> String {
        "second restaurant id"
    }

    private func firstReviewText() -> String {
        "first review text"
    }

    private func secondReviewText() -> String {
        "second review text"
    }

    private func firstStarsNumber() -> Int {
        3
    }

    private func secondStarsNumber() -> Int {
        5
    }

    private func firstCreatedAt() -> Date {
        Date(timeIntervalSince1970: 1675865291)
    }

    private func secondCreatedAt() -> Date {
        Date(timeIntervalSince1970: 1562860291)
    }

    private func expectedAllReviews() -> [Review] {
        expectedReviewsForFirstRestaurantID() + expectedReviewsForSecondRestaurantID()
    }

    private func expectedReviewsForFirstRestaurantID() -> [Review] {
        [
            Review(
                restaurantID: "restaurant #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: testingNewName,
                reviewText: firstReviewText(),
                rating: firstStarsNumber(),
                relativeTime: "14 hours ago"
            )
        ]
    }

    private func expectedReviewsForSecondRestaurantID() -> [Review] {
        [
            Review(
                restaurantID: "restaurant #2",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: testingNewName,
                reviewText: secondReviewText(),
                rating: secondStarsNumber(),
                relativeTime: "3 years ago"
            )
        ]
    }
}

private extension User {
    func isEqual(to user: User) -> Bool {
        name == user.name &&
        email == user.email &&
        profileImage == user.profileImage
    }
}

private extension Array where Element == Review {
    func isEqual(to reviews: [Review]) -> Bool {
        guard count == reviews.count else { return false }

        let equals = (0..<count).filter {
            if !self[$0].isEqual(to: reviews[$0]) {
                return false
            }

            return true
        }

        return equals.count == count
    }
}

private extension Review {
    func isEqual(to review: Review) -> Bool {
        authorName == review.authorName &&
        reviewText == review.reviewText &&
        rating == review.rating
    }
}
