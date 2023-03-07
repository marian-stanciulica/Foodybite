//
//  DistanceProvider.swift
//  Domain
//
//  Created by Marian Stanciulica on 07.03.2023.
//

public protocol DistanceProvider {
    func getDistanceInKm(from source: Location, to destination: Location) -> Double
}
