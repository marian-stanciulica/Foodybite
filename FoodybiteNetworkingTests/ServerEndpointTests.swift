//
//  ServerEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 13.10.2022.
//

import XCTest

enum ServerEndpoint {
    case signup(name: String)
    
    var path: String {
        "/auth/signup"
    }
    
    var method: String {
        "POST"
    }
    
    var body: [String: String] {
        switch self {
        case let .signup(name):
            return ["name" : name]
        }
    }
}

final class ServerEndpointTests: XCTestCase {

    func test_signup_path() {
        XCTAssertEqual(makeSUT().path, "/auth/signup")
    }
    
    func test_signup_methodIsPost() {
        XCTAssertEqual(makeSUT().method, "POST")
    }
    
    func test_signup_bodyContainsName() {
        XCTAssertEqual(makeSUT().body["name"], anyName())
    }
    
    // MARK: - Helpers
    
    private func anyName() -> String {
        "any name"
    }
    
    private func makeSUT() -> ServerEndpoint {
        return .signup(name: anyName())
    }

}
