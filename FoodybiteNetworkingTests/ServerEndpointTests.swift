//
//  ServerEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest

enum ServerEndpoint {
    case signup(name: String, email: String, password: String, confirmPassword: String)
    
    var path: String {
        "/auth/signup"
    }
    
    var method: String {
        "POST"
    }
    
    var body: [String : String] {
        var body = [String : String]()
        
        switch self {
        case let .signup(name, email, password, confirmPassword):
            body["name"] = name
            body["email"] = email
            body["password"] = password
            body["confirm_password"] = confirmPassword
        }
        
        return body
    }
    
    var headers: [String : String] {
        ["Content-Type" : "application/json"]
    }
}

final class ServerEndpointTests: XCTestCase {

    func test_signup_path() {
        XCTAssertEqual(makeSUT().path, "/auth/signup")
    }
    
    func test_signup_methodIsPost() {
        XCTAssertEqual(makeSUT().method, "POST")
    }
    
    func test_signup_bodyContainsName() {
        XCTAssertEqual(makeSUT().body["name"], anyName())
    }
    
    func test_signup_bodyContainsEmail() {
        XCTAssertEqual(makeSUT().body["email"], anyEmail())
    }
    
    func test_signup_bodyContainsPassword() {
        XCTAssertEqual(makeSUT().body["password"], anyPassword())
    }
    
    func test_signup_bodyContainsConfirmPassword() {
        XCTAssertEqual(makeSUT().body["confirm_password"], anyPassword())
    }
    
    func test_signup_headersContainContentTypeJson() {
        XCTAssertEqual(makeSUT().headers["Content-Type"], "application/json")
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
    
    private func makeSUT() -> ServerEndpoint {
        return .signup(name: anyName(), email: anyEmail(), password: anyPassword(), confirmPassword: anyPassword())
    }

}
