//
//  DistanceSolver.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import Domain
import CoreLocation

public final class DistanceSolver {

    public static func getDistanceInKm(from source: Location, to destination: Location) -> Double {
        let source = CLLocation(latitude: source.latitude, longitude: source.longitude)
        let destination = CLLocation(latitude: destination.latitude, longitude: destination.longitude)

        let result = source.distance(from: destination) / 1000
        return roundDistance(result)
    }

    private static func roundDistance(_ number: Double) -> Double {
        round(number * 10) / 10.0
    }

}
