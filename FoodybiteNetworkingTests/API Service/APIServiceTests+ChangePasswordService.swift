//
//  APIServiceTests+ChangePasswordService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {
    
    func test_conformsToChangePasswordService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as ChangePasswordService)
    }
    
    func test_changePassword_usesChangePasswordEndpointToCreateURLRequest() async throws {
        let currentPassword = anyPassword()
        let newPassword = anyPassword()
        let (sut, _, sender, _) = makeSUT()
        
        try await sut.changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: newPassword
        )
        
        XCTAssertEqual(sender.requests.count, 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/changePassword",
            method: .post,
            body: makeChangePasswordRequestBody(currentPassword: currentPassword, newPassword: newPassword))
    }
    
    // MARK: - Helpers
    
    private func makeChangePasswordRequestBody(currentPassword: String, newPassword: String) -> ChangePasswordRequest {
        ChangePasswordRequest(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmPassword: newPassword
        )
    }
}
