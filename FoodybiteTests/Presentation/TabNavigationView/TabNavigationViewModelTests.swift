//
//  TabNavigationViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import XCTest
import DomainModels

final class TabNavigationViewModel {
    enum State {
        case isLoading
    }
    
    private let locationProvider: LocationProviding
    var state: State = .isLoading
    var locationServicesEnabled: Bool {
        locationProvider.locationServicesEnabled
    }
    
    init(locationProvider: LocationProviding) {
        self.locationProvider = locationProvider
    }
    
    func getCurrentLocation() async {
        state = .isLoading
        _ = try? await locationProvider.requestLocation()
    }
}

final class TabNavigationViewModelTests: XCTestCase {
    
    func test_locationServicesEnabled_equalsToLocationProviderLocationServicesEnabled() {
        let (sut, locationProviderSpy) = makeSUT()
        
        locationProviderSpy.locationServicesEnabled = false
        XCTAssertFalse(sut.locationServicesEnabled)
        
        locationProviderSpy.locationServicesEnabled = true
        XCTAssertTrue(sut.locationServicesEnabled)
    }
    
    func test_getCurrentLocation_setsStateToLoading() async {
        let (sut, _) = makeSUT()
        
        await sut.getCurrentLocation()
        
        XCTAssertEqual(sut.state, .isLoading)
    }
    
    func test_getCurrentLocation_callsLocationProvider() async {
        let (sut, locationProviderSpy) = makeSUT()
        
        await sut.getCurrentLocation()
        
        XCTAssertEqual(locationProviderSpy.requestLocationCallCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: TabNavigationViewModel, locationProviderSpy: LocationProvidingSpy) {
        let locationProviderSpy = LocationProvidingSpy()
        let sut = TabNavigationViewModel(locationProvider: locationProviderSpy)
        return (sut, locationProviderSpy)
    }
    
    private class LocationProvidingSpy: LocationProviding {
        var locationServicesEnabled: Bool = false
        private(set) var requestLocationCallCount = 0
        
        func requestLocation() async throws -> Location {
            requestLocationCallCount += 1
            throw NSError(domain: "any error", code: 1)
        }
    }
    
}
