//
//  APIServiceTests+AccountService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    func test_conformsToUpdateAccountService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as AccountService)
    }

    func test_updateAccount_usesUpdateAccountEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()

        try await sut.updateAccount(
            name: anyName(),
            email: anyEmail(),
            profileImage: anyData()
        )

        XCTAssertEqual(sender.requests.count, 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/account",
            method: .post,
            body: makeUpdateAccountRequestBody())
    }

    func test_deleteAccount_usesDeleteAccountEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()

        try await sut.deleteAccount()

        XCTAssertEqual(sender.requests.count, 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/account",
            method: .delete,
            body: nil)
    }

    // MARK: - Helpers

    private func makeUpdateAccountRequestBody() -> UpdateAccountRequestBody {
        UpdateAccountRequestBody(name: anyName(), email: anyEmail(), profileImage: anyData())
    }

}
