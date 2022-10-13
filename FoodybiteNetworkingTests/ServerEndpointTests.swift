//
//  ServerEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest

enum ServerEndpoint {
    case signup
    
    var path: String {
        "/auth/signup"
    }
}

final class ServerEndpointTests: XCTestCase {

    func test_signup_path() {
        XCTAssertEqual(ServerEndpoint.signup.path, "/auth/signup")
    }
    

}
