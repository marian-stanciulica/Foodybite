//
//  APIServiceTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class APIServiceTests: XCTestCase {
    
    // MARK: - LoginService Tests
    
    func test_conformsToLoginService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as LoginService)
    }
    
    func test_login_loginParamsUsedToCreateEndpoint() async throws {
        let email = anyEmail()
        let password = anyPassword()
        
        let (sut, loader, _, _) = makeSUT()
        let loginEndpoint = ServerEndpoint.login(LoginRequest(email: email, password: password))
        let urlRequest = try loginEndpoint.createURLRequest()
        
        _ = try await sut.login(email: email, password: password)
        
        let firstRequest = loader.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_login_usesLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        
        let (sut, loader, _, _) = makeSUT()
        let loginEndpoint = ServerEndpoint.login(LoginRequest(email: email, password: password))
        let urlRequest = try loginEndpoint.createURLRequest()
        
        _ = try await sut.login(email: email, password: password)
        
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_login_receiveExpectedLoginResponse() async throws {
        let expectedResponse = anyLoginResponse()
        let (sut, _, _, _) = makeSUT(loginResponse: expectedResponse)
        
        let receivedResponse = try await sut.login(email: anyEmail(), password: anyPassword())
        
        XCTAssertEqual(expectedResponse.user, receivedResponse)
    }
    
    func test_login_storesAuthTokenInKeychain() async throws {
        let expectedResponse = anyLoginResponse()
        let (sut, _, _, tokenStoreStub) = makeSUT(loginResponse: expectedResponse)
        
        _ = try await sut.login(email: anyEmail(), password: anyPassword())
        let receivedToken = try tokenStoreStub.read()
        
        XCTAssertEqual(receivedToken, expectedResponse.token)
    }
    
    // MARK: - SignUpService Tests
    
    func test_conformsToSignUpService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as SignUpService)
    }
    
    func test_signUp_paramsUsedToCreateEndpoint() async throws {
        let name = anyName()
        let email = anyEmail()
        let password = anyPassword()
        let confirmPassword = anyPassword()
        let profileImage = anyData()
        
        let (sut, _, sender, _) = makeSUT()
        let signUpEndpoint = ServerEndpoint.signup(SignUpRequest(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: anyData()))
        let urlRequest = try signUpEndpoint.createURLRequest()
        
        try await sut.signUp(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage)
        
        let firstRequest = sender.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_signUp_usesSignUpEndpointToCreateURLRequest() async throws {
        let name = anyName()
        let email = anyEmail()
        let password = anyPassword()
        let confirmPassword = anyPassword()
        let profileImage = anyData()
        
        let (sut, _, sender, _) = makeSUT()
        let signUpEndpoint = ServerEndpoint.signup(SignUpRequest(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage))
        let urlRequest = try signUpEndpoint.createURLRequest()
        
        try await sut.signUp(name: name, email: email, password: password, confirmPassword: confirmPassword, profileImage: profileImage)

        XCTAssertEqual(sender.requests, [urlRequest])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(loginResponse: LoginResponse? = nil) -> (sut: APIService, loader: ResourceLoaderSpy, sender: ResourceSenderSpy, tokenStoreStub: TokenStoreStub) {
        let tokenStoreStub = TokenStoreStub()
        let loader = ResourceLoaderSpy(response: loginResponse ?? anyLoginResponse())
        let sender = ResourceSenderSpy()
        let sut = APIService(loader: loader, sender: sender, tokenStore: tokenStoreStub)
        return (sut, loader, sender, tokenStoreStub)
    }
    
    private func anyName() -> String {
        "any name"
    }
    
    private func anyEmail() -> String {
        "test@test.com"
    }
    
    private func anyPassword() -> String {
        "123@password$321"
    }
    
    private func anyData() -> Data? {
        "any data".data(using: .utf8)
    }
    
    private func anyLoginResponse() -> LoginResponse {
        LoginResponse(
            user: RemoteUser(id: UUID(),
                             name: "any name",
                             email: "any@email.com",
                             profileImage: nil,
                             followingCount: 0,
                             followersCount: 0),
            token: AuthToken(accessToken: "any access token",
                             refreshToken: "any refresh token")
        )
    }

}
