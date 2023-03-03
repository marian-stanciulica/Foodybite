//
//  RefreshTokenEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybiteNetworking

final class RefreshTokenEndpointTests: XCTestCase {
    
    func test_refreshToken_path() {
        XCTAssertEqual(makeSUT().path, "/auth/accessToken")
    }
    
    func test_refreshToken_methodIsPost() {
        XCTAssertEqual(makeSUT().method, .post)
    }
    
    func test_refreshToken_body() throws {
        let randomRefreshToken = randomString(size: 20)
        let body = RefreshTokenRequest(refreshToken: randomRefreshToken)
        let sut = makeSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? RefreshTokenRequest)
        XCTAssertEqual(receivedBody, body)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(body: RefreshTokenRequest? = nil) -> RefreshTokenEndpoint {
        let defaultBody = RefreshTokenRequest(refreshToken: "")
        return .post(body ?? defaultBody)
    }
}
