//
//  APIServiceTests+LoginService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    func test_conformsToLoginService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as LoginService)
    }

    func test_login_usesLoginEndpointToCreateURLRequest() async throws {
        let email = anyEmail()
        let password = anyPassword()
        let hashedPassword = hash(password: password)
        let (sut, loader, _, _) = makeSUT(response: anyLoginResponse())

        _ = try await sut.login(email: email, password: password)

        XCTAssertEqual(loader.requests.count, 1)
        assertURLComponents(
            urlRequest: loader.requests[0],
            path: "/auth/login",
            method: .post,
            body: LoginRequestBody(email: email, password: hashedPassword))
    }

    func test_login_receiveExpectedLoginResponse() async throws {
        let expectedModel = anyLoginResponse()
        let (sut, _, _, _) = makeSUT(response: expectedModel)

        let receivedUser = try await sut.login(email: anyEmail(), password: anyPassword())

        XCTAssertEqual(expectedModel.remoteUser.model, receivedUser)
    }

    func test_login_storesAuthTokenInKeychain() async throws {
        let (sut, _, _, tokenStoreStub) = makeSUT(response: anyLoginResponse())

        _ = try await sut.login(email: anyEmail(), password: anyPassword())
        let receivedToken = try tokenStoreStub.read()

        XCTAssertEqual(receivedToken, anyAuthToken())
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
