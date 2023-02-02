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
}

final class LocationFetcher: NSObject, CLLocationManagerDelegate {
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        super.init()
        
        self.locationManager.delegate = self
    }
}

final class LocationFetcherTests: XCTestCase {
    
    func test_init_locationManagerDelegateSetToSelf() {
        let locationManagerStub = LocationManagerStub()
        let sut = LocationFetcher(locationManager: locationManagerStub)
        
        XCTAssertIdentical(locationManagerStub.delegate, sut)
    }
    
    // MARK: - Helpers
    
    private class LocationManagerStub: LocationManager {
        var delegate: CLLocationManagerDelegate?
    }
    
}
