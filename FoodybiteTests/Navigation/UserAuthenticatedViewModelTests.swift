//
//  UserAuthenticatedViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 03.02.2023.
//

import XCTest
import Domain
import Foodybite

final class UserAuthenticatedViewModelTests: XCTestCase {
    
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
        
        XCTAssertEqual(sut.state, .failure(.unauthorized))
    }
    
    func test_getCurrentLocation_setsStateToLoadedWhenLocationProviderReturnsLocation() async {
        let (sut, locationProviderSpy) = makeSUT()
        locationProviderSpy.result = .success(anyLocation())
        
        await sut.getCurrentLocation()
        
        XCTAssertEqual(sut.state, .success(anyLocation()))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: UserAuthenticatedViewModel, locationProviderSpy: LocationProvidingSpy) {
        let locationProviderSpy = LocationProvidingSpy()
        let sut = UserAuthenticatedViewModel(locationProvider: locationProviderSpy)
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
    }
    
}
