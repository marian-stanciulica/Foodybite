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
    
    // MARK: - Helpers
    
    private func makeSUT() -> APIService {
        let httpClient = URLSessionHTTPClient()
        let tokenStore = KeychainTokenStore()
        
        let remoteResourceLoader = RemoteResourceLoader(client: httpClient)
        return APIService(loader: remoteResourceLoader,
                          sender: remoteResourceLoader,
                          tokenStore: tokenStore)
    }
    
    private var testingName: String {
        "Testing"
    }
    
    private var testingEmail: String {
        "testing@testing.com"
    }
    
    private var testingPassword: String {
        "123Password321$"
    }
    
    private var testingProfileImage: Data? {
        "any data".data(using: .utf8)
    }
    
}
