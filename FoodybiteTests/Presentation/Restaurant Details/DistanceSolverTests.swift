//
//  DistanceSolverTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import DomainModels
import CoreLocation

final class DistanceSolver {
    
    static func getDistanceInKm(from source: Location, to destination: Location) -> Double {
        let source = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)

        let result = source.distance(from: destination) / 1.000
        return roundDistance(result)
    }
    
    private static func roundDistance(_ number: Double) -> Double {
        round(number * 10) / 10.0
    }
    
}

final class DistanceSolverTests: XCTestCase {
    
    func test_getDistanceInKm_computesDistance() {
        let source = Location(latitude: 4.5, longitude: 2.3)
        let destination = Location(latitude: 4.4, longitude: 2.3)
        
        let result = DistanceSolver.getDistanceInKm(from: source, to: destination)
       XCTAssertEqual(result, 11058.1)
    }
    
}
