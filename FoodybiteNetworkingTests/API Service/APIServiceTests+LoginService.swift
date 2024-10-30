//
//  APIServiceTests+LoginService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
import Foundation.NSUUID
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    @Test func conformsToLoginService() {
        let (sut, _, _, _) = makeSUT()
        #expect(sut as LoginService != nil)
    }

    @Test func login_usesLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        let hashedPassword = hash(password: password)
        let (sut, loader, _, _) = makeSUT(response: anyLoginResponse())

        _ = try await sut.login(email: email, password: password)

        #expect(loader.requests.count == 1)
        assertURLComponents(
            urlRequest: loader.requests[0],
            path: "/auth/login",
            method: .post,
            body: LoginRequestBody(email: email, password: hashedPassword))
    }

    @Test func login_receiveExpectedLoginResponse() async throws {
        let expectedModel = anyLoginResponse()
        let (sut, _, _, _) = makeSUT(response: expectedModel)

        let receivedUser = try await sut.login(email: anyEmail(), password: anyPassword())

        #expect(expectedModel.remoteUser.model == receivedUser)
    }

    @Test func login_storesAuthTokenInKeychain() async throws {
        let (sut, _, _, tokenStoreStub) = makeSUT(response: anyLoginResponse())

        _ = try await sut.login(email: anyEmail(), password: anyPassword())
        let receivedToken = try tokenStoreStub.read()

        #expect(receivedToken == anyAuthToken())
    }

    // MARK: - Helpers

    private func anyLoginResponse() -> LoginResponse {
        LoginResponse(
            remoteUser: RemoteUser(
                id: UUID(),
                name: "any name",
                email: "any@email.com",
                profileImage: nil
            ),
            token: anyAuthToken()
        )
    }

    private func anyAuthToken() -> AuthToken {
        AuthToken(accessToken: "any access token",
                         refreshToken: "any refresh token")
    }
}
