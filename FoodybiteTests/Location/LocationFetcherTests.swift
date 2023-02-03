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
}

final class LocationFetcher: NSObject, LocationManagerDelegate, CLLocationManagerDelegate {
    private var locationManager: LocationManager
    var continuation: CheckedContinuation<Location, Error>?
    
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
}

final class LocationFetcherTests: XCTestCase {
    
    func test_init_locationManagerDelegateSetToSelf() {
        let (sut, locationManagerSpy) = makeSUT()
        
        XCTAssertIdentical(locationManagerSpy.delegate, sut)
    }
    
    func test_locationManagerDidChangeAuthorization_callsRequestWhenInUseAuthorizationWhenAuthorizationStatusIsNotDetermined() {
        let (sut, locationManagerSpy) = makeSUT()
        
        sut.locationManagerDidChangeAuthorization(manager: locationManagerSpy)
        
        XCTAssertEqual(locationManagerSpy.requestWhenInUseAuthorizationCallCount, 1)
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
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: LocationFetcher, locationManagerSpy: LocationManagerSpy) {
        let locationManagerSpy = LocationManagerSpy()
        let sut = LocationFetcher(locationManager: locationManagerSpy)
        return (sut, locationManagerSpy)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
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
