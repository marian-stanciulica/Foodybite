//
//  FlowTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 13.11.2022.
//

import XCTest
import Foodybite

final class FlowTests: XCTestCase {
    
    func test_append_appendsValueToNavigationPath() {
        let sut = Flow<AuthRoute>()
        
        XCTAssertEqual(sut.path.count, 0)
        
        sut.append(.signUp)
        XCTAssertEqual(sut.path.count, 1)
    }
    
    func test_navigateBack_removesLastValueFromNavigationPath() {
        let sut = Flow<AuthRoute>()
        
        sut.append(.signUp)
        XCTAssertEqual(sut.path.count, 1)
        
        sut.navigateBack()
        XCTAssertEqual(sut.path.count, 0)
    }
}
