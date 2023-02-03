//
//  LocationManagerDelegate.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import CoreLocation

public protocol LocationManagerDelegate {
    func locationManagerDidChangeAuthorization(manager: LocationManager)
    func locationManager(manager: LocationManager, didFailWithError error: Error)
    func locationManager(manager: LocationManager, didUpdateLocations locations: [CLLocation])
}
