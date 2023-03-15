//
//  APIServiceTests+LogoutService.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import XCTest
@testable import FoodybiteNetworking
import Domain

extension APIServiceTests {
    
    func test_conformsToLogoutService() {
        let (sut, _, _, _) = makeSUT()
        XCTAssertNotNil(sut as LogoutService)
    }
    
    func test_logout_usesLogoutEndpointToCreateURLRequest() async throws {
        let (sut, _, sender, _) = makeSUT()
        
        try await sut.logout()

        XCTAssertEqual(sender.requests.count, 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/logout",
            method: .post,
            body: nil)
    }
    
}
