//
//  DistanceSolverTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Domain
import FoodybiteLocation

final class DistanceSolverTests: XCTestCase {

    func test_getDistanceInKm_computesDistance() {
        let source = Location(latitude: 4.5, longitude: 2.3)
        let destination = Location(latitude: 4.4, longitude: 2.3)

        let result = DistanceSolver.getDistanceInKm(from: source, to: destination)
       XCTAssertEqual(result, 11.1)
    }

}
