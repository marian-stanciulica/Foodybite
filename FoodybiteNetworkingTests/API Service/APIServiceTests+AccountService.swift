//
//  APIServiceTests+AccountService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    @Test func conformsToUpdateAccountService() {
        let (sut, _, _, _) = makeSUT()
        #expect(sut as AccountService != nil)
    }

    @Test func updateAccount_usesUpdateAccountEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()

        try await sut.updateAccount(
            name: anyName(),
            email: anyEmail(),
            profileImage: anyData()
        )

        #expect(sender.requests.count == 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/account",
            method: .post,
            body: makeUpdateAccountRequestBody())
    }

    @Test func deleteAccount_usesDeleteAccountEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()

        try await sut.deleteAccount()

        #expect(sender.requests.count == 1)
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
