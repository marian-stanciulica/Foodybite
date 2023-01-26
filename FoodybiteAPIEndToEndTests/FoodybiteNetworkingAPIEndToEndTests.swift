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

    func test_endToEndSignUp_returnsSuccesfully() async {
        let apiService = makeSUT()
        
        do {
            try await apiService.signUp(name: testingName,
                                        email: testingEmail,
                                        password: testingPassword,
                                        confirmPassword: testingPassword,
                                        profileImage: testingProfileImage)
        } catch {
            XCTFail("Expected successful sign up request, got \(error) instead")
        }
    }
    
    func test_endToEndLogin_returnsExpectedUser() async {
        let apiService = makeSUT()
        
        do {
            let receivedUser = try await apiService.login(email: testingEmail, password: testingPassword)
            XCTAssertTrue(receivedUser.isEqual(to: expectedUser))
        } catch {
            XCTFail("Expected successful login request, got \(error) instead")
        }
    }
    
    func test_endToEndChangePassword_returnsSuccessfully() async {
        let apiService = makeAuthenticatedSUT()
        
        do {
            try await apiService.changePassword(currentPassword: testingPassword,
                                                newPassword: testingNewPassword,
                                                confirmPassword: testingNewPassword)
        } catch {
            XCTFail("Expected successful change password request, got \(error) instead")
        }
    }
    
    func test_endToEndLogout_returnsSuccessfully() async {
        let apiService = makeAuthenticatedSUT()
        
        do {
            try await apiService.logout()
        } catch {
            XCTFail("Expected successful logout request, got \(error) instead")
        }
    }
    
    func test_endToEndUpdateAccount_returnsSuccessfully() async {
        let apiService = makeAuthenticatedSUT()
        
        do {
            try await apiService.updateAccount(name: testingNewName,
                                               email: testingEmail,
                                               profileImage: testingNewProfileImage)
        } catch {
            XCTFail("Expected successful update account request, got \(error) instead")
        }
    }
    
    func test_endToEndDeleteAccount_returnsSuccessfully() async {
        let apiService = makeAuthenticatedSUT()
        
        do {
            try await apiService.deleteAccount()
        } catch {
            XCTFail("Expected successful delete account request, got \(error) instead")
        }
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
