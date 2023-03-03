//
//  SignUpEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest
@testable import FoodybiteNetworking

final class SignUpEndpointTests: XCTestCase {

    func test_signup_path() {
        XCTAssertEqual(makeSUT().path, "/auth/signup")
    }
    
    func test_signup_methodIsPost() {
        XCTAssertEqual(makeSUT().method, .post)
    }
    
    func test_signup_body() throws {
        let body = SignUpRequest(name: anyName(),
                                 email: anyEmail(),
                                 password: anyPassword(),
                                 confirmPassword: anyPassword(),
                                 profileImage: anyData())
        let sut = makeSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? SignUpRequest)
        
        XCTAssertEqual(receivedBody, body)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(body: SignUpRequest? = nil) -> SignUpEndpoint {
        let defaultBody = SignUpRequest(name: anyName(),
                                        email: anyEmail(),
                                        password: anyPassword(),
                                        confirmPassword: anyPassword(),
                                        profileImage: anyData())
        return .post(body ?? defaultBody)
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
    
    private func anyData() -> Data {
        "any name".data(using: .utf8)!
    }
}
