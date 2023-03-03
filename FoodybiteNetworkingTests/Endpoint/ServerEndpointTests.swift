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
    
    private func makeSignUpSUT(body: SignUpRequest? = nil) -> ServerEndpoint {
        let defaultBody = SignUpRequest(name: anyName(),
                                        email: anyEmail(),
                                        password: anyPassword(),
                                        confirmPassword: anyPassword(),
                                        profileImage: anyData())
        
        return .signup(body ?? defaultBody)
    }
}
