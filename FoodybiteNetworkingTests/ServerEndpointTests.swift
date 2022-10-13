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
    
    var method: String {
        "POST"
    }
    
}

final class ServerEndpointTests: XCTestCase {

    func test_signup_path() {
        XCTAssertEqual(ServerEndpoint.signup.path, "/auth/signup")
    }
    
    func test_signup_methodIsPost() {
        XCTAssertEqual(ServerEndpoint.signup.method, "POST")
    }
    

}
