//
//  LocationProviderTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 02.02.2023.
//

import Testing
import CoreLocation
import Domain
@testable import FoodybiteLocation

struct LocationProviderTests {

    @Test func init_locationManagerDelegateSetToSelf() {
        let (sut, locationManagerSpy) = makeSUT()

        #expect(locationManagerSpy.delegate === sut)
    }

    @Test func requestWhenInUseAuthorization_callsRequestWhenInUseAuthorizationOnLocationManager() {
        let (sut, locationManagerSpy) = makeSUT()

        sut.requestWhenInUseAuthorization()

        #expect(locationManagerSpy.requestWhenInUseAuthorizationCallCount == 1)
    }

    @Test func locationManagerDidChangeAuthorization_setsLocationServicesEnabledAccordingly() {
        assertLocationsServicesEnabled(for: .authorizedWhenInUse, withExpectedResult: true)
        assertLocationsServicesEnabled(for: .authorizedAlways, withExpectedResult: true)
        assertLocationsServicesEnabled(for: .denied, withExpectedResult: false)
        assertLocationsServicesEnabled(for: .restricted, withExpectedResult: false)
    }

    @Test func requestLocation_throwsErrorWhenLocationServicesAreDisabled() async throws {
        let (sut, _) = makeSUT()
        sut.locationServicesEnabled = false

        await expectRequestLocationError(on: sut)
    }

    @Test func requestLocation_throwsErrorWhenLocationManagerDidFailWithErrorCalled() async throws {
        let (sut, locationManagerSpy) = makeSUT()
        sut.locationServicesEnabled = true

        Task {
            sut.locationManager(manager: locationManagerSpy, didFailWithError: anyError())
        }

        await expectRequestLocationError(on: sut)
    }

    @Test func requestLocation_returnsLocationWhenLocationManagerDidUpdateLocationsCalled() async throws {
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
                                                sourceLocation: SourceLocation = #_sourceLocation) {
        let (sut, locationManagerSpy) = makeSUT()
        locationManagerSpy.authorizationStatus = authorizationStatus

        sut.locationManagerDidChangeAuthorization(manager: locationManagerSpy)

        #expect(sut.locationServicesEnabled == result, sourceLocation: sourceLocation)
    }

    private func expectRequestLocationError(on sut: LocationProvider,
                                            sourceLocation: SourceLocation = #_sourceLocation) async {
        do {
            let location = try await sut.requestLocation()
            Issue.record("Expected to receive an error, got \(location) instead", sourceLocation: sourceLocation)
        } catch {
            #expect(error != nil, sourceLocation: sourceLocation)
        }
    }

    private func expectRequestLocationSuccess(on sut: LocationProvider,
                                              expectedLocation: Location,
                                              sourceLocation: SourceLocation = #_sourceLocation) async {
        do {
            let receivedLocation = try await sut.requestLocation()
            #expect(receivedLocation == expectedLocation, sourceLocation: sourceLocation)
        } catch {
            Issue.record("Expected to receive \(anyLocations().firstLocation), got \(error) instead", sourceLocation: sourceLocation)
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
