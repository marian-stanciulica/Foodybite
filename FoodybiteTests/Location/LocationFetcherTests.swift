//
//  LocationFetcherTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 02.02.2023.
//

import XCTest
import CoreLocation

protocol LocationManager {
    var delegate: CLLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }

    func requestWhenInUseAuthorization()
}

extension CLLocationManager: LocationManager {}

protocol LocationManagerDelegate {
    func locationManagerDidChangeAuthorization(manager: LocationManager)
}

final class LocationFetcher: NSObject, LocationManagerDelegate, CLLocationManagerDelegate {
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init()
        
        self.locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationManagerDidChangeAuthorization(manager: manager)
    }
    
    func locationManagerDidChangeAuthorization(manager: LocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
}

final class LocationFetcherTests: XCTestCase {
    
    func test_init_locationManagerDelegateSetToSelf() {
        let locationManagerStub = LocationManagerStub()
        let sut = LocationFetcher(locationManager: locationManagerStub)
        
        XCTAssertIdentical(locationManagerStub.delegate, sut)
    }
    
    func test_locationManagerDidChangeAuthorization_callsRequestWhenInUseAuthorizationWhenAuthorizationStatusIsNotDetermined() {
        let locationManagerStub = LocationManagerStub()
        let sut = LocationFetcher(locationManager: locationManagerStub)
        
        sut.locationManagerDidChangeAuthorization(manager: locationManagerStub)
        
        XCTAssertEqual(locationManagerStub.requestWhenInUseAuthorizationCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private class LocationManagerStub: LocationManager {
        var delegate: CLLocationManagerDelegate?
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var requestWhenInUseAuthorizationCallCount = 0
        
        func requestWhenInUseAuthorization() {
            requestWhenInUseAuthorizationCallCount += 1
        }
    }
    
}
