//
//  APIServiceTests+SignUpService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    func test_conformsToSignUpService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as SignUpService)
    }

    func test_signUp_usesSignUpEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()
        let password = anyPassword()
        let hashedPassword = hash(password: password)

        try await sut.signUp(
            name: anyName(),
            email: anyEmail(),
            password: password,
            profileImage: anyData()
        )

        XCTAssertEqual(sender.requests.count, 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/signup",
            method: .post,
            body: makeSignUpRequestBody(password: hashedPassword))
    }

    // MARK: - Helpers

    private func makeSignUpRequestBody(password: String) -> SignUpRequestBody {
        SignUpRequestBody(
            name: anyName(),
            email: anyEmail(),
            password: password,
            profileImage: anyData()
        )
    }

}
