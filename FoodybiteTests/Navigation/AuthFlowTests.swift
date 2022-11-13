//
//  AuthFlowTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import XCTest

final class AuthFlow {
    enum Route {
        case signUp
        case turnOnLocation
    }
}

extension AuthFlow.Route: CaseIterable {}

final class AuthFlowTests: XCTestCase {

    func test_route_containsSignUpAndTurnOnLocation() {
        XCTAssertEqual(AuthFlow.Route.allCases, [.signUp, .turnOnLocation])
    }
}
