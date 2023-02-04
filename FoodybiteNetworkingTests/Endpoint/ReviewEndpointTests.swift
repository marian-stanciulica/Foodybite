//
//  ReviewEndpointTests.swift
//  FoodybiteNetworkingTests
//
//  Created by Marian Stanciulica on 04.02.2023.
//

import XCTest
import FoodybiteNetworking

final class ReviewEndpointTests: XCTestCase {
    
    func test_addReview_baseURL() {
        XCTAssertEqual(makeSUT().host, "localhost")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ReviewEndpoint {
        return .addReview
    }
    
}
