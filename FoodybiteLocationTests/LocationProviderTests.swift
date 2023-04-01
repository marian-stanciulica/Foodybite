//
//  LocationProviderTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 02.02.2023.
//

import XCTest
import CoreLocation
import Domain
import FoodybiteLocation

final class LocationProviderTests: XCTestCase {
    
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
        sut.locationServicesEnabled = true
        let exp = expectation(description: "Wait for task")
        
        let task = Task {
            exp.fulfill()
            return try await sut.requestLocation()
        }

        task.cancel()
        await fulfillment(of: [exp])
        
        XCTAssertEqual(locationManagerSpy.requestLocationCallCount, 1)
    }
    
    func test_requestLocation_throwsErrorWhenLocationServicesAreDisabled() async throws {
        let (sut, _) = makeSUT()
        sut.locationServicesEnabled = false
        
        await expectRequestLocationError(on: sut)
    }
    
    func test_requestLocation_throwsErrorWhenLocationManagerDidFailWithErrorCalled() async throws {
        let (sut, locationManagerSpy) = makeSUT()
        sut.locationServicesEnabled = true

        Task {
            sut.locationManager(manager: locationManagerSpy, didFailWithError: anyError())
        }
        
        await expectRequestLocationError(on: sut)
    }
    
    func test_requestLocation_returnsLocationWhenLocationManagerDidUpdateLocationsCalled() async throws {
        let (sut, locationManagerSpy) = makeSUT()
        sut.locationServicesEnabled = true

        Task {
            sut.locationManager(manager: locationManagerSpy, didUpdateLocations: anyLocations().locations)
        }
        
        await expectRequestLocationSuccess(on: sut, expectedLocation: anyLocations().firstLocation)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocationProvider, locationManagerSpy: LocationManagerSpy) {
        let locationManagerSpy = LocationManagerSpy()
        let sut = LocationProvider(locationManager: locationManagerSpy)
        return (sut, locationManagerSpy)
    }
    
    private func assertLocationsServicesEnabled(for authorizationStatus: CLAuthorizationStatus,
                                                withExpectedResult result: Bool,
                                                file: StaticString = #filePath,
                                                line: UInt = #line) {
        let (sut, locationManagerSpy) = makeSUT()
        locationManagerSpy.authorizationStatus = authorizationStatus
        
        sut.locationManagerDidChangeAuthorization(manager: locationManagerSpy)
        
        XCTAssertEqual(sut.locationServicesEnabled, result, file: file, line: line)
    }
    
    private func expectRequestLocationError(on sut: LocationProvider,
                                            file: StaticString = #filePath,
                                            line: UInt = #line) async {
        do {
            let location = try await sut.requestLocation()
            XCTFail("Expected to receive an error, got \(location) instead", file: file, line: line)
        } catch {
            XCTAssertNotNil(error, file: file, line: line)
        }
    }
    
    private func expectRequestLocationSuccess(on sut: LocationProvider,
                                              expectedLocation: Location,
                                              file: StaticString = #filePath,
                                              line: UInt = #line) async {
        do {
            let receivedLocation = try await sut.requestLocation()
            XCTAssertEqual(receivedLocation, expectedLocation, file: file, line: line)
        } catch {
            XCTFail("Expected to receive \(anyLocations().firstLocation), got \(error) instead", file: file, line: line)
        }
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
