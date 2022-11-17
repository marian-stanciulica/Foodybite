//
//  ServerEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class ServerEndpointTests: XCTestCase {

    // MARK: - Sign up
    
    func test_signup_baseURL() {
        XCTAssertEqual(makeSignUpSUT().host, "localhost")
    }
    
    func test_signup_path() {
        XCTAssertEqual(makeSignUpSUT().path, "/auth/signup")
    }
    
    func test_signup_methodIsPost() {
        XCTAssertEqual(makeSignUpSUT().method, .post)
    }
    
    func test_signup_body() throws {
        let body = SignUpRequest(name: anyName(),
                                 email: anyEmail(),
                                 password: anyPassword(),
                                 confirmPassword: anyPassword(),
                                 profileImage: anyData())
        let sut = makeSignUpSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? SignUpRequest)
        
        XCTAssertEqual(receivedBody, body)
    }
    
    func test_signup_headersContainContentTypeJson() {
        XCTAssertEqual(makeSignUpSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Login
    
    func test_login_baseURL() {
        XCTAssertEqual(makeLoginSUT().host, "localhost")
    }
    
    func test_login_path() {
        XCTAssertEqual(makeLoginSUT().path, "/auth/login")
    }
    
    func test_login_methodIsPost() {
        XCTAssertEqual(makeLoginSUT().method, .post)
    }
    
    func test_login_body() throws {
        let body = LoginRequest(email: anyEmail(), password: anyPassword())

        let sut = makeLoginSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? LoginRequest)
        
        XCTAssertEqual(receivedBody, body)
    }
    
    func test_login_headersContainContentTypeJson() {
        XCTAssertEqual(makeLoginSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: Refresh Token
    
    func test_refreshToken_baseURL() {
        XCTAssertEqual(makeRefreshTokenSUT().host, "localhost")
    }
    
    func test_refreshToken_path() {
        XCTAssertEqual(makeRefreshTokenSUT().path, "/auth/accessToken")
    }
    
    func test_refreshToken_methodIsPost() {
        XCTAssertEqual(makeRefreshTokenSUT().method, .post)
    }
    
    func test_refreshToken_bodyContainsEmail() {
        let randomRefreshToken = randomString(size: 20)
        let sut = makeRefreshTokenSUT(refreshToken: randomRefreshToken)
        XCTAssertEqual(sut.body as? String, randomRefreshToken)
    }
    
    func test_refreshToken_headersContainContentTypeJson() {
        XCTAssertEqual(makeRefreshTokenSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Helpers
    
    private func anyName() -> String {
        "any name"
    }
    
    private func anyEmail() -> String {
        "email@any.com"
    }
    
    private func anyPassword() -> String {
        "123$Password@321"
    }
    
    private func anyData() -> Data {
        "any name".data(using: .utf8)!
    }
    
    private func randomString(size: Int) -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        return String(Array(0..<size).map { _ in chars.randomElement()! })
    }
    
    private func makeSignUpSUT(body: SignUpRequest? = nil) -> ServerEndpoint {
        let defaultBody = SignUpRequest(name: anyName(),
                                        email: anyEmail(),
                                        password: anyPassword(),
                                        confirmPassword: anyPassword(),
                                        profileImage: anyData())
        
        return .signup(body ?? defaultBody)
    }
    
    private func makeLoginSUT(body: LoginRequest? = nil) -> ServerEndpoint {
        let defaultBody = LoginRequest(email: anyEmail(), password: anyPassword())
        
        return .login(body ?? defaultBody)
    }
    
    private func makeRefreshTokenSUT(refreshToken: String = "") -> ServerEndpoint {
        return .refreshToken(refreshToken)
    }

}
