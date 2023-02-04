//
//  ReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import XCTest

final class ReviewViewModel {
    enum State {
        case idle
    }
    
    var state: State = .idle
}

final class ReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let sut = ReviewViewModel()
        
        XCTAssertEqual(sut.state, .idle)
    }
    
}
