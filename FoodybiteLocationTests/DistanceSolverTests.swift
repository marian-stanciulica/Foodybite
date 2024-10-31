//
//  DistanceSolverTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Testing
import Domain
import FoodybiteLocation

struct DistanceSolverTests {

    @Test func getDistanceInKm_computesDistance() {
        let source = Location(latitude: 4.5, longitude: 2.3)
        let destination = Location(latitude: 4.4, longitude: 2.3)

        let result = DistanceSolver.getDistanceInKm(from: source, to: destination)
       #expect(result == 11.1)
    }

}
