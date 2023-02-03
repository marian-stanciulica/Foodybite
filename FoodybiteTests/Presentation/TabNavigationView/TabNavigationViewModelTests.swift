//
//  TabNavigationViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import XCTest

final class TabNavigationViewModel {
    enum State {
        case isLoading
    }
    
    var state: State = .isLoading
    
    func getCurrentLocation() {
        state = .isLoading
    }
}

final class TabNavigationViewModelTests: XCTestCase {
    
    func test_getCurrentLocation_setsStatetoLoading() {
        let sut = TabNavigationViewModel()
        
        sut.getCurrentLocation()
        
        XCTAssertEqual(sut.state, .isLoading)
    }
    
}
