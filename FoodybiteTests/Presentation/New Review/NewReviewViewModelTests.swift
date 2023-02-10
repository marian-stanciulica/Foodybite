//
//  NewReviewViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 10.02.2023.
//

import XCTest

final class NewReviewViewModel {
    public enum State: Equatable {
        case idle
    }
    
    public var state: State = .idle
    public var reviewText = ""
    public var starsNumber = 0
}

final class NewReviewViewModelTests: XCTestCase {
    
    func test_init_stateIsIdle() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.state, .idle)
        XCTAssertEqual(sut.reviewText, "")
        XCTAssertEqual(sut.starsNumber, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> NewReviewViewModel {
        return NewReviewViewModel()
    }
    
}
