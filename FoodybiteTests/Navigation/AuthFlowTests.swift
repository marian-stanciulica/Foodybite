//
//  AuthFlowTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import XCTest
import Foodybite

final class AuthFlowTests: XCTestCase {

    func test_route_containsSignUpAndTurnOnLocation() {
        XCTAssertEqual(AuthFlow.Route.allCases, [.signUp])
    }
    
    func test_append_appendsValueToNavigationPath() {
        let sut = AuthFlow()
        
        XCTAssertEqual(sut.path.count, 0)
        
        sut.append(.signUp)
        XCTAssertEqual(sut.path.count, 1)
    }
    
    func test_navigateBack_removesLastValueFromNavigationPath() {
        let sut = AuthFlow()
        
        sut.append(.signUp)
        XCTAssertEqual(sut.path.count, 1)
        
        sut.navigateBack()
        XCTAssertEqual(sut.path.count, 0)
    }
}
