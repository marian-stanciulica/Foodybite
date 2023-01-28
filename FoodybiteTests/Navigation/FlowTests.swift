//
//  FlowTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import XCTest
import Foodybite

final class FlowTests: XCTestCase {
    
    func test_authRoute_containsAllCases() {
        XCTAssertEqual(AuthRoute.allCases, [.signUp])
    }
    
    func test_profileRoute_containsAllCases() {
        XCTAssertEqual(ProfileRoute.allCases, [.settings, .changePassword, .editProfile])
    }
    
    func test_append_appendsValueToNavigationPath() {
        let sut = Flow<AuthRoute>()
        
        XCTAssertEqual(sut.path.count, 0)
        
        sut.append(.signUp)
        XCTAssertEqual(sut.path.count, 1)
    }
    
    func test_navigateBack_removesLastValueFromNavigationPath() {
        let sut = Flow<ProfileRoute>()
        
        sut.append(.settings)
        XCTAssertEqual(sut.path, [.settings])
        
        sut.append(.changePassword)
        XCTAssertEqual(sut.path, [.settings, .changePassword])
        
        sut.navigateBack()
        XCTAssertEqual(sut.path, [.settings])
        
        sut.navigateBack()
        XCTAssertTrue(sut.path.isEmpty)
    }
}
