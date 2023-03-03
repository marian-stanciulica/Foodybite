//
//  LoginEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybiteNetworking

final class LoginEndpointTests: XCTestCase {
    
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
    
    // MARK: - Helpers
    
    private func makeLoginSUT(body: LoginRequest? = nil) -> LoginEndpoint {
        let defaultBody = LoginRequest(email: anyEmail(), password: anyPassword())
        
        return .login(body ?? defaultBody)
    }
    
    private func anyName() -> String {
        "any name"
    }
    
    private func anyEmail() -> String {
        "email@any.com"
    }
    
    private func anyPassword() -> String {
        "123$Password@321"
    }
}
