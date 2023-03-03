//
//  LogoutEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybiteNetworking

final class LogoutEndpointTests: XCTestCase {
    
    func test_logout_path() {
        XCTAssertEqual(makeSUT().path, "/auth/logout")
    }
    
    func test_logout_methodIsPost() {
        XCTAssertEqual(makeSUT().method, .post)
    }
    
    func test_logout_bodyContainsChangePasswordRequest() throws {
        let sut = makeSUT()
        XCTAssertNil(sut.body)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> LogoutEndpoint {
        return .post
    }
}
