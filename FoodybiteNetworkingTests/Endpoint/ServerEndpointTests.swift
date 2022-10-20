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
    
    func test_signup_bodyContainsName() {
        XCTAssertEqual(makeSignUpSUT().body["name"], anyName())
    }
    
    func test_signup_bodyContainsEmail() {
        XCTAssertEqual(makeSignUpSUT().body["email"], anyEmail())
    }
    
    func test_signup_bodyContainsPassword() {
        XCTAssertEqual(makeSignUpSUT().body["password"], anyPassword())
    }
    
    func test_signup_bodyContainsConfirmPassword() {
        XCTAssertEqual(makeSignUpSUT().body["confirm_password"], anyPassword())
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
    
    func test_login_bodyContainsEmail() {
        XCTAssertEqual(makeLoginSUT().body["email"], anyEmail())
    }
    
    func test_login_bodyContainsPassword() {
        XCTAssertEqual(makeLoginSUT().body["password"], anyPassword())
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
        XCTAssertEqual(sut.body["refreshToken"], randomRefreshToken)
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
    
    private func randomString(size: Int) -> String {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        return String(Array(0..<size).map { _ in chars.randomElement()! })
    }
    
    private func makeSignUpSUT() -> ServerEndpoint {
        return .signup(name: anyName(), email: anyEmail(), password: anyPassword(), confirmPassword: anyPassword())
    }
    
    private func makeLoginSUT() -> ServerEndpoint {
        return .login(email: anyEmail(), password: anyPassword())
    }
    
    private func makeRefreshTokenSUT(refreshToken: String = "") -> ServerEndpoint {
        return .refreshToken(refreshToken)
    }

}
