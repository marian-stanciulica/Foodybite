//
//  APIServiceTests+ChangePasswordService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    @Test func conformsToChangePasswordService() {
        let (sut, _, _, _) = makeSUT()
        #expect(sut as ChangePasswordService != nil)
    }

    @Test func changePassword_usesChangePasswordEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()

        let currentPassword = anyPassword()
        let hashedCurrentPassword = hash(password: currentPassword)

        let newPassword = anyPassword()
        let hashedNewPassword = hash(password: newPassword)

        try await sut.changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword
        )

        #expect(sender.requests.count == 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/changePassword",
            method: .post,
            body: makeChangePasswordRequestBody(
                currentPassword: hashedCurrentPassword,
                newPassword: hashedNewPassword
            )
        )
    }

    // MARK: - Helpers

    private func makeChangePasswordRequestBody(currentPassword: String, newPassword: String) -> ChangePasswordRequestBody {
        ChangePasswordRequestBody(
            currentPassword: currentPassword,
            newPassword: newPassword
        )
    }
}
