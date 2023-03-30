//
//  LocationManager.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import CoreLocation

public protocol LocationManager {
    var delegate: CLLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }

    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationManager {}
