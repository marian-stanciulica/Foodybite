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
        
        try await sut.signUp(
            name: anyName(),
            email: anyEmail(),
            password: anyPassword(),
            confirmPassword: anyPassword(),
            profileImage: anyData()
        )
        
        XCTAssertEqual(sender.requests.count, 1)
        assertURLComponents(
            urlRequest: sender.requests[0],
            path: "/auth/signup",
            method: .post,
            body: makeSignUpRequestBody())
    }
    
    // MARK: - Helpers
    
    private func makeSignUpRequestBody() -> SignUpRequestBody {
        SignUpRequestBody(
            name: anyName(),
            email: anyEmail(),
            password: anyPassword(),
            confirmPassword: anyPassword(),
            profileImage: anyData()
        )
    }
    
}
