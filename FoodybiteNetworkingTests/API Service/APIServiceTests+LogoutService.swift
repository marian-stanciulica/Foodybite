//
//  APIServiceTests+LogoutService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {

    @Test func conformsToLogoutService() {
        let (sut, _, _, _) = makeSUT()
        #expect(sut as LogoutService != nil)
    }

    @Test func logout_usesLogoutEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()

        try await sut.logout()

        #expect(sender.requests.count == 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/logout",
            method: .post,
            body: nil)
    }

}
