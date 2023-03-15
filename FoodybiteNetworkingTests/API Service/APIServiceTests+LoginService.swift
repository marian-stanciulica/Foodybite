//
//  APIServiceTests+LoginService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {
    
    func test_conformsToLoginService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as LoginService)
    }
    
    func test_login_usesLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        let (sut, loader, _, _) = makeSUT(response: anyLoginResponse().response)
        
        _ = try await sut.login(email: email, password: password)
        
        XCTAssertEqual(loader.requests.count, 1)
        assertURLComponents(
            urlRequest: loader.requests[0],
            path: "/auth/login",
            method: .post,
            body: LoginRequest(email: email, password: password))
    }
    
    func test_login_receiveExpectedLoginResponse() async throws {
        let (response, expectedModel) = anyLoginResponse()
        let (sut, _, _, _) = makeSUT(response: response)
        
        let receivedResponse = try await sut.login(email: anyEmail(), password: anyPassword())
        
        XCTAssertEqual(expectedModel, receivedResponse)
    }
    
    func test_login_storesAuthTokenInKeychain() async throws {
        let (sut, _, _, tokenStoreStub) = makeSUT(response: anyLoginResponse().response)
        
        _ = try await sut.login(email: anyEmail(), password: anyPassword())
        let receivedToken = try tokenStoreStub.read()
        
        XCTAssertEqual(receivedToken, anyAuthToken())
    }
    
    // MARK: - Helpers
    
    private func anyLoginResponse() -> (response: LoginResponse, model: User) {
        let id = UUID()
        let response = LoginResponse(
            user: RemoteUser(id: id,
                             name: "any name",
                             email: "any@email.com",
                             profileImage: nil),
            token: anyAuthToken()
        )
        
        let model = User(id: id, name: "any name", email: "any@email.com", profileImage: nil)
        return (response, model)
    }
    
    private func anyAuthToken() -> AuthToken {
        AuthToken(accessToken: "any access token",
                         refreshToken: "any refresh token")
    }
}
