//
//  TabNavigationViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import XCTest
import DomainModels

final class TabNavigationViewModel {
    enum State: Equatable {
        case isLoading
        case loadingError(message: String)
        case loaded(location: Location)
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
        
        do {
            _ = try await locationProvider.requestLocation()
        } catch {
            state = .loadingError(message: "Location couldn't be fetched. Try again!")
        }
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
    
    func test_state_initialStateIsLoading() async {
        let (sut, _) = makeSUT()
        
        XCTAssertEqual(sut.state, .isLoading)
    }
    
    func test_getCurrentLocation_callsLocationProvider() async {
        let (sut, locationProviderSpy) = makeSUT()
        
        await sut.getCurrentLocation()
        
        XCTAssertEqual(locationProviderSpy.requestLocationCallCount, 1)
    }
    
    func test_getCurrentLocation_setsStateToErrorWhenLocationProviderThrowsError() async {
        let (sut, locationProviderSpy) = makeSUT()
        locationProviderSpy.result = .failure(anyError())
        
        await sut.getCurrentLocation()
        
        XCTAssertEqual(sut.state, .loadingError(message: "Location couldn't be fetched. Try again!"))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: TabNavigationViewModel, locationProviderSpy: LocationProvidingSpy) {
        let locationProviderSpy = LocationProvidingSpy()
        let sut = TabNavigationViewModel(locationProvider: locationProviderSpy)
        return (sut, locationProviderSpy)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
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
    }
    
}
