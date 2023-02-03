//
//  LocationProvider.swift
//  Foodybite
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import CoreLocation
import DomainModels

public final class LocationProvider: NSObject, LocationProviding {
    private var locationManager: LocationManager
    private var continuation: CheckedContinuation<Location, Error>?
    public var locationServicesEnabled = false
    
    private enum LocationError: Swift.Error {
        case locationServicesDisabled
    }
    
    public init(locationManager: LocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        
        self.locationManager.delegate = self
    }
    
    public func requestLocation() async throws -> Location {
        guard locationServicesEnabled else {
            throw LocationError.locationServicesDisabled
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.requestLocation()
        }
    }
}

extension LocationProvider: LocationManagerDelegate  {
    
    public func locationManagerDidChangeAuthorization(manager: LocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationServicesEnabled = true
        default:
            locationServicesEnabled = false
        }
    }
    
    public func locationManager(manager: LocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
    
    public func locationManager(manager: LocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            let location = Location(latitude: firstLocation.coordinate.latitude,
                                    longitude: firstLocation.coordinate.longitude)
            continuation?.resume(returning: location)
            continuation = nil
        }
    }
    
}

extension LocationProvider: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManagerDidChangeAuthorization(manager: manager)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager(manager: manager, didFailWithError: error)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager(manager: manager, didUpdateLocations: locations)
    }
    
}
