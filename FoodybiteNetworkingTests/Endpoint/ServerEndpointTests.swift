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
    
    func test_signup_headersContainContentTypeJSON() {
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
    
    func test_login_headersContainContentTypeJSON() {
        XCTAssertEqual(makeLoginSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Refresh Token
    
    func test_refreshToken_baseURL() {
        XCTAssertEqual(makeRefreshTokenSUT().host, "localhost")
    }
    
    func test_refreshToken_path() {
        XCTAssertEqual(makeRefreshTokenSUT().path, "/auth/accessToken")
    }
    
    func test_refreshToken_methodIsPost() {
        XCTAssertEqual(makeRefreshTokenSUT().method, .post)
    }
    
    func test_refreshToken_body() throws {
        let randomRefreshToken = randomString(size: 20)
        let body = RefreshTokenRequest(refreshToken: randomRefreshToken)
        let sut = makeRefreshTokenSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? RefreshTokenRequest)
        XCTAssertEqual(receivedBody, body)
    }
    
    func test_refreshToken_headersContainContentTypeJSON() {
        XCTAssertEqual(makeRefreshTokenSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Change Password
    
    func test_changePassword_baseURL() {
        XCTAssertEqual(makeChangePasswordSUT().host, "localhost")
    }
    
    func test_changePassword_path() {
        XCTAssertEqual(makeChangePasswordSUT().path, "/auth/changePassword")
    }
    
    func test_changePassword_methodIsPost() {
        XCTAssertEqual(makeChangePasswordSUT().method, .post)
    }
    
    func test_changePassword_bodyContainsChangePasswordRequest() throws {
        let currentPassword = randomString(size: 20)
        let newPassword = randomString(size: 20)
        let confirmPassword = newPassword
        let body = ChangePasswordRequest(currentPassword: currentPassword,
                                         newPassword: newPassword,
                                         confirmPassword: confirmPassword)

        let sut = makeChangePasswordSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? ChangePasswordRequest)
        XCTAssertEqual(receivedBody, body)
    }
    
    func test_changePassword_headersContainContentTypeJSON() {
        XCTAssertEqual(makeChangePasswordSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Logout
    
    func test_logout_baseURL() {
        XCTAssertEqual(makeLogoutSUT().host, "localhost")
    }
    
    func test_logout_path() {
        XCTAssertEqual(makeLogoutSUT().path, "/auth/logout")
    }
    
    func test_logout_methodIsPost() {
        XCTAssertEqual(makeLogoutSUT().method, .post)
    }
    
    func test_logout_bodyContainsChangePasswordRequest() throws {
        let sut = makeLogoutSUT()
        XCTAssertNil(sut.body)
    }
    
    func test_logout_headersContainContentTypeJSON() {
        XCTAssertEqual(makeLogoutSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Update Account
    
    func test_updateAccount_baseURL() {
        XCTAssertEqual(makeUpdateAccountSUT().host, "localhost")
    }
    
    func test_updateAccount_path() {
        XCTAssertEqual(makeUpdateAccountSUT().path, "/auth/account")
    }
    
    func test_updateAccount_methodIsPost() {
        XCTAssertEqual(makeUpdateAccountSUT().method, .post)
    }
    
    func test_updateAccount_bodyContainsUpdateAccountRequest() throws {
        let body = UpdateAccountRequest(name: anyName(), email: anyEmail(), profileImage: anyData())
        let sut = makeUpdateAccountSUT(body: body)
        
        let receivedBody = try XCTUnwrap(sut.body as? UpdateAccountRequest)
        XCTAssertEqual(receivedBody, body)
    }
    
    func test_updateAccount_headersContainContentTypeJSON() {
        XCTAssertEqual(makeUpdateAccountSUT().headers["Content-Type"], "application/json")
    }
    
    // MARK: - Delete Account
    
    func test_deleteAccount_baseURL() {
        XCTAssertEqual(makeDeleteAccountSUT().host, "localhost")
    }
    
    func test_deleteAccount_path() {
        XCTAssertEqual(makeDeleteAccountSUT().path, "/auth/account")
    }
    
    func test_deleteAccount_methodIsPost() {
        XCTAssertEqual(makeDeleteAccountSUT().method, .delete)
    }
    
    func test_deleteAccount_headersContainContentTypeJSON() {
        XCTAssertEqual(makeDeleteAccountSUT().headers["Content-Type"], "application/json")
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
    
    private func makeRefreshTokenSUT(body: RefreshTokenRequest? = nil) -> ServerEndpoint {
        let defaultBody = RefreshTokenRequest(refreshToken: "")
        
        return .refreshToken(body ?? defaultBody)
    }
    
    private func makeChangePasswordSUT(body: ChangePasswordRequest? = nil) -> ServerEndpoint {
        let defaultBody = ChangePasswordRequest(currentPassword: "",
                                                newPassword: "",
                                                confirmPassword: "")
        
        return .changePassword(body ?? defaultBody)
    }
    
    private func makeLogoutSUT() -> ServerEndpoint {
        return .logout
    }
    
    private func makeUpdateAccountSUT(body: UpdateAccountRequest? = nil) -> ServerEndpoint {
        let defaultBody = UpdateAccountRequest(name: "", email: "", profileImage: nil)
        return .updateAccount(body ?? defaultBody)
    }
    
    private func makeDeleteAccountSUT() -> ServerEndpoint {
        return .deleteAccount
    }

}
