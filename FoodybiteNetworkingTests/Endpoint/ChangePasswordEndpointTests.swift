//
//  ChangePasswordEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 03.03.2023.
//

import XCTest
@testable import FoodybiteNetworking

final class ChangePasswordEndpointTests: XCTestCase {
    
    func test_changePassword_path() {
        XCTAssertEqual(makeSUT().path, "/auth/changePassword")
    }
    
    func test_changePassword_methodIsPost() {
        XCTAssertEqual(makeSUT().method, .post)
    }
    
    func test_changePassword_bodyContainsChangePasswordRequest() throws {
        let currentPassword = randomString(size: 20)
        let newPassword = randomString(size: 20)
        let confirmPassword = newPassword
        let body = ChangePasswordRequest(currentPassword: currentPassword,
                                         newPassword: newPassword,
                                         confirmPassword: confirmPassword)

        let sut = makeSUT(body: body)
        let receivedBody = try XCTUnwrap(sut.body as? ChangePasswordRequest)
        XCTAssertEqual(receivedBody, body)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(body: ChangePasswordRequest? = nil) -> ChangePasswordEndpoint {
        let defaultBody = ChangePasswordRequest(currentPassword: "",
                                                newPassword: "",
                                                confirmPassword: "")
        return .post(body ?? defaultBody)
    }
}
