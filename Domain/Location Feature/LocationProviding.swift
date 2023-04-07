//
//  LocationProviding.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.02.2023.
//

public protocol LocationProviding {
    var locationServicesEnabled: Bool { get }

    func requestWhenInUseAuthorization()
    func requestLocation() async throws -> Location
}
