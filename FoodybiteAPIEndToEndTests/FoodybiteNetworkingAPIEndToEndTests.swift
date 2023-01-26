//
//  FoodybiteNetworkingAPIEndToEndTests.swift
//  FoodybiteAPIEndToEndTests
//
//  Created by Marian Stanciulica on 26.01.2023.
//

import XCTest
import DomainModels
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
    
    func test_6endToEndDeleteAccount_returnsSuccessfully() async {
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
}

private extension User {
    func isEqual(to user: User) -> Bool {
        name == user.name &&
        email == user.email &&
        profileImage == user.profileImage
    }
}
