//
//  FetchLocationViewModelTests.swift
//  FoodybitePresentationTests
//
//  Created by Marian Stanciulica on 06.05.2023.
//

import Testing
import Foundation.NSError
import Domain
import FoodybitePresentation

struct FetchLocationViewModelTests {

    @Test func locationServicesEnabled_equalsToLocationProviderLocationServicesEnabled() {
        let (sut, locationProviderSpy) = makeSUT()

        locationProviderSpy.locationServicesEnabled = false
        #expect(sut.locationServicesEnabled == false)

        locationProviderSpy.locationServicesEnabled = true
        #expect(sut.locationServicesEnabled == true)
    }

    @Test func state_initialStateIsLoading() async {
        let (sut, _) = makeSUT()

        #expect(sut.state == .isLoading)
    }

    @Test func getCurrentLocation_callsLocationProvider() async {
        let (sut, locationProviderSpy) = makeSUT()

        await sut.getCurrentLocation()

        #expect(locationProviderSpy.requestLocationCallCount == 1)
    }

    @Test func getCurrentLocation_setsStateToErrorWhenLocationProviderThrowsError() async {
        let (sut, locationProviderSpy) = makeSUT()
        locationProviderSpy.result = .failure(anyError())

        await sut.getCurrentLocation()

        #expect(sut.state == .failure(.unauthorized))
    }

    @Test func getCurrentLocation_setsStateToLoadedWhenLocationProviderReturnsLocation() async {
        let (sut, locationProviderSpy) = makeSUT()
        locationProviderSpy.result = .success(anyLocation())

        await sut.getCurrentLocation()

        #expect(sut.state == .success(anyLocation()))
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: FetchLocationViewModel, locationProviderSpy: LocationProvidingSpy) {
        let locationProviderSpy = LocationProvidingSpy()
        let sut = FetchLocationViewModel(locationProvider: locationProviderSpy)
        return (sut, locationProviderSpy)
    }

    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }

    private func anyLocation() -> Location {
        Location(latitude: 2.3, longitude: 4.5)
    }

    private class LocationProvidingSpy: LocationProviding {
        var locationServicesEnabled: Bool = false
        var result: Result<Location, Error>?
        private(set) var requestLocationCallCount = 0

        func requestLocation() async throws -> Location {
            requestLocationCallCount += 1

            if let result = result {
                return try result.get()
            }

            throw NSError(domain: "any error", code: 1)
        }

        func requestWhenInUseAuthorization() {}
    }

}
