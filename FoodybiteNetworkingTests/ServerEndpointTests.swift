//
//  ServerEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest

enum ServerEndpoint {
    case signup(name: String, email: String, password: String, confirmPassword: String)
    case login(email: String, password: String)
    
    var path: String {
        switch self {
        case .signup:
            return "/auth/signup"
        case .login:
            return "/auth/login"
        }
        
    }
    
    var method: String {
        "POST"
    }
    
    var headers: [String : String] {
        ["Content-Type" : "application/json"]
    }
    
    var body: [String : String] {
        var body = [String : String]()
        
        switch self {
        case let .signup(name, email, password, confirmPassword):
            body["name"] = name
            body["email"] = email
            body["password"] = password
            body["confirm_password"] = confirmPassword
        case let .login(email, password):
            body["email"] = email
            body["password"] = password
        }
        
        return body
    }
    
    var urlParams: [String : String] {
        [:]
    }
}

final class ServerEndpointTests: XCTestCase {

    func test_signup_path() {
        XCTAssertEqual(makeSignUpSUT().path, "/auth/signup")
    }
    
    func test_signup_methodIsPost() {
        XCTAssertEqual(makeSignUpSUT().method, "POST")
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
    
    func test_signup_emptyUrlParams() {
        XCTAssertTrue(makeSignUpSUT().urlParams.isEmpty)
    }
    
    func test_login_path() {
        XCTAssertEqual(makeLoginSUT().path, "/auth/login")
    }
    
    func test_login_methodIsPost() {
        XCTAssertEqual(makeLoginSUT().method, "POST")
    }
    
    func test_login_bodyContainsEmail() {
        XCTAssertEqual(makeLoginSUT().body["email"], anyEmail())
    }
    
    func test_login_bodyContainsPassword() {
        XCTAssertEqual(makeLoginSUT().body["password"], anyPassword())
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
    
    private func makeSignUpSUT() -> ServerEndpoint {
        return .signup(name: anyName(), email: anyEmail(), password: anyPassword(), confirmPassword: anyPassword())
    }
    
    private func makeLoginSUT() -> ServerEndpoint {
        return .login(email: anyEmail(), password: anyPassword())
    }

}
