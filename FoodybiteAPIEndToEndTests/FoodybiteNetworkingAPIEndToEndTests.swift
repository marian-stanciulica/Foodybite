//
//  FoodybiteNetworkingAPIEndToEndTests.swift
//  FoodybiteAPIEndToEndTests
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import XCTest
import Domain
import FoodybiteNetworking

final class FoodybiteNetworkingAPIEndToEndTests: XCTestCase {

    func test_1endToEndSignUp_returnsSuccesfully() async {
        await execute(action: {
            try await makeSUT().signUp(name: testingName,
                                       email: testingEmail,
                                       password: testingPassword,
                                       confirmPassword: testingPassword,
                                       profileImage: testingProfileImage)
        })
    }
    
    func test_2endToEndLogin_returnsExpectedUser() async {
        await executeLogin()
    }
    
    func test_3endToEndChangePassword_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().changePassword(currentPassword: testingPassword,
                                                            newPassword: testingNewPassword,
                                                            confirmPassword: testingNewPassword)
        })
    }
    
    func test_4endToEndLogout_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().logout()
        })
    }
    
    func test_5endToEndUpdateAccount_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().updateAccount(name: testingNewName,
                                                           email: testingEmail,
                                                           profileImage: testingNewProfileImage)
        })
    }
    
    func test_6endToEndAddReview_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().addReview(
                placeID: firstPlaceID(),
                reviewText: firstReviewText(),
                starsNumber: firstStarsNumber(),
                createdAt: firstCreatedAt()
            )
        })
    }
    
    func test_7endToEndGetReviews_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().addReview(
                placeID: secondPlaceID(),
                reviewText: secondReviewText(),
                starsNumber: secondStarsNumber(),
                createdAt: secondCreatedAt()
            )
        })
        
        await executeGetReviews(placeID: firstPlaceID(), expectedReviews: expectedReviewsForFirstPlaceID())
        await executeGetReviews(placeID: secondPlaceID(), expectedReviews: expectedReviewsForSecondPlaceID())
        await executeGetReviews(expectedReviews: expectedAllReviews())
    }
    
    func test_8endToEndDeleteAccount_returnsSuccessfully() async {
        await execute(action: {
            try await makeAuthenticatedSUT().deleteAccount()
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> APIService {
        let httpClient = URLSessionHTTPClient()
        let tokenStore = KeychainTokenStore()
        
        let remoteResourceLoader = RemoteResourceLoader(client: httpClient)
        return APIService(loader: remoteResourceLoader,
                          sender: remoteResourceLoader,
                          tokenStore: tokenStore)
    }
    
    private func makeAuthenticatedSUT() -> APIService {
        let httpClient = URLSessionHTTPClient()
        let refreshTokenLoader = RemoteResourceLoader(client: httpClient)
        let tokenStore = KeychainTokenStore()
        
        let tokenRefresher = RefreshTokenService(loader: refreshTokenLoader, tokenStore: tokenStore)
        let authenticatedHTTPClient = AuthenticatedURLSessionHTTPClient(decoratee: httpClient, tokenRefresher: tokenRefresher)
        let authenticatedRemoteResourceLoader = RemoteResourceLoader(client: authenticatedHTTPClient)
        
        return APIService(loader: authenticatedRemoteResourceLoader,
                          sender: authenticatedRemoteResourceLoader,
                          tokenStore: tokenStore)
    }
    
    private func execute(action: () async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            try await action()
        } catch {
            XCTFail("Expected successful request, got \(error) instead", file: file, line: line)
        }
    }
    
    private func executeLogin(file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let receivedUser = try await makeSUT().login(email: testingEmail, password: testingPassword)
            XCTAssertTrue(receivedUser.isEqual(to: expectedUser), file: file, line: line)
        } catch {
            XCTFail("Expected successful login request, got \(error) instead", file: file, line: line)
        }
    }
    
    private func executeGetReviews(placeID: String? = nil, expectedReviews: [Review], file: StaticString = #filePath, line: UInt = #line) async {
        do {
            let receivedReviews = try await makeAuthenticatedSUT().getReviews(placeID: placeID)
            XCTAssertTrue(receivedReviews.isEqual(to: expectedReviews), file: file, line: line)
        } catch {
            XCTFail("Expected successful get reviews, got \(error) instead", file: file, line: line)
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
    
    private func firstPlaceID() -> String {
        "first place id"
    }
    
    private func secondPlaceID() -> String {
        "second place id"
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
        expectedReviewsForFirstPlaceID() + expectedReviewsForSecondPlaceID()
    }
    
    private func expectedReviewsForFirstPlaceID() -> [Review] {
        [
            Review(
                placeID: "place #1",
                profileImageURL: nil,
                profileImageData: nil,
                authorName: testingNewName,
                reviewText: firstReviewText(),
                rating: firstStarsNumber(),
                relativeTime: "14 hours ago"
            )
        ]
    }
    
    private func expectedReviewsForSecondPlaceID() -> [Review] {
        [
            Review(
                placeID: "place #2",
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
