//
//  LocationFetcherTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 02.02.2023.
//

import XCTest
import CoreLocation
import DomainModels

protocol LocationManager {
    var delegate: CLLocationManagerDelegate? { get set }
    var authorizationStatus: CLAuthorizationStatus { get }

    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager: LocationManager {}

protocol LocationManagerDelegate {
    func locationManagerDidChangeAuthorization(manager: LocationManager)
    func locationManager(manager: LocationManager, didFailWithError error: Error)
    func locationManager(manager: LocationManager, didUpdateLocations locations: [CLLocation])
}

final class LocationFetcher: NSObject, LocationManagerDelegate, CLLocationManagerDelegate {
    private var locationManager: LocationManager
    private var continuation: CheckedContinuation<Location, Error>?
    var locationServicesEnabled = false
    
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
        case .authorizedWhenInUse, .authorizedAlways:
            locationServicesEnabled = true
        default:
            locationServicesEnabled = false
        }
    }
    
    func requestLocation() async throws -> Location {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: LocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager(manager: manager, didFailWithError: error)
    }
    
    func locationManager(manager: LocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            let location = Location(latitude: firstLocation.coordinate.latitude,
                                    longitude: firstLocation.coordinate.longitude)
            continuation?.resume(returning: location)
            continuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager(manager: manager, didUpdateLocations: locations)
    }
}

final class LocationFetcherTests: XCTestCase {
    
    func test_init_locationManagerDelegateSetToSelf() {
        let (sut, locationManagerSpy) = makeSUT()
        
        XCTAssertIdentical(locationManagerSpy.delegate, sut)
    }
    
    func test_locationManagerDidChangeAuthorization_callsRequestWhenInUseAuthorizationWhenAuthorizationStatusIsNotDetermined() {
        let (sut, locationManagerSpy) = makeSUT()
        locationManagerSpy.authorizationStatus = .notDetermined
        
        sut.locationManagerDidChangeAuthorization(manager: locationManagerSpy)
        
        XCTAssertEqual(locationManagerSpy.requestWhenInUseAuthorizationCallCount, 1)
    }
    
    func test_locationManagerDidChangeAuthorization_setsLocationServicesEnabledAccordingly() {
        assertLocationsServicesEnabled(for: .authorizedWhenInUse, withExpectedResult: true)
        assertLocationsServicesEnabled(for: .authorizedAlways, withExpectedResult: true)
        assertLocationsServicesEnabled(for: .denied, withExpectedResult: false)
        assertLocationsServicesEnabled(for: .restricted, withExpectedResult: false)
    }
    
    func test_requestLocation_callsRequestLocationOnLocationManager() async throws {
        let (sut, locationManagerSpy) = makeSUT()
        let exp = expectation(description: "Wait for task")
        
        let task = Task {
            exp.fulfill()
            return try await sut.requestLocation()
        }

        task.cancel()
        await waitForExpectations(timeout: 1.0)
        
        XCTAssertEqual(locationManagerSpy.requestLocationCallCount, 1)
    }
    
    func test_requestLocation_throwsErrorWhenLocationManagerDidFailWithErrorCalled() async throws {
        let (sut, locationManagerSpy) = makeSUT()

        Task {
            sut.locationManager(manager: locationManagerSpy, didFailWithError: anyError())
        }
        
        do {
            let location = try await sut.requestLocation()
            XCTFail("Expected to receive an error, got \(location) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_requestLocation_returnsLocationWhenLocationManagerDidUpdateLocationsCalled() async throws {
        let (sut, locationManagerSpy) = makeSUT()

        Task {
            sut.locationManager(manager: locationManagerSpy, didUpdateLocations: anyLocations().locations)
        }
        
        do {
            let receivedLocation = try await sut.requestLocation()
            XCTAssertEqual(receivedLocation, anyLocations().firstLocation)
        } catch {
            XCTFail("Expected to receive \(anyLocations().firstLocation), got \(error) instead")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocationFetcher, locationManagerSpy: LocationManagerSpy) {
        let locationManagerSpy = LocationManagerSpy()
        let sut = LocationFetcher(locationManager: locationManagerSpy)
        return (sut, locationManagerSpy)
    }
    
    private func assertLocationsServicesEnabled(for authorizationStatus: CLAuthorizationStatus,
                                                withExpectedResult result: Bool,
                                                file: StaticString = #filePath,
                                                line: UInt = #line) {
        let (sut, locationManagerSpy) = makeSUT()
        locationManagerSpy.authorizationStatus = authorizationStatus
        
        sut.locationManagerDidChangeAuthorization(manager: locationManagerSpy)
        
        XCTAssertEqual(sut.locationServicesEnabled, result)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyLocations() -> (firstLocation: Location, locations: [CLLocation]) {
        let firstLocation = Location(latitude: 1.1, longitude: 3.2)
        
        let locations = [
            CLLocation(latitude: 1.1, longitude: 3.2),
            CLLocation(latitude: -6.5, longitude: 7.4),
            CLLocation(latitude: 12.4, longitude: -9.2),
            CLLocation(latitude: -112.4, longitude: -54.5)
        ]
        
        return (firstLocation, locations)
    }
    
    private class LocationManagerSpy: LocationManager {
        var delegate: CLLocationManagerDelegate?
        var authorizationStatus: CLAuthorizationStatus = .notDetermined
        
        var requestWhenInUseAuthorizationCallCount = 0
        var requestLocationCallCount = 0
        
        func requestWhenInUseAuthorization() {
            requestWhenInUseAuthorizationCallCount += 1
        }
        
        func requestLocation() {
            requestLocationCallCount += 1
        }
    }
    
}
