//
//  NearbyRestaurantsServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import Foodybite

final class NearbyRestaurantsServiceWithFallbackCompositeTests: XCTestCase {
    
    func test_searchNearby_returnsNearbyRestaurantsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        primaryStub.stub = .success(expectedNearbyRestaurants)
        
        let receivedNearbyRestaurants = try await searchNearby(on: sut)
        
        XCTAssertEqual(receivedNearbyRestaurants, expectedNearbyRestaurants)
    }
    
    func test_searchNearby_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedLocation = anyLocation()
        let expectedRadius = 100
        primaryStub.stub = .failure(anyError())
        
        _ = try await searchNearby(on: sut, location: expectedLocation, radius: expectedRadius)
        
        XCTAssertEqual(secondaryStub.capturedValues.count, 1)
        XCTAssertEqual(secondaryStub.capturedValues[0].location, expectedLocation)
        XCTAssertEqual(secondaryStub.capturedValues[0].radius, expectedRadius)
    }
    
    func test_searchNearby_returnsNearbyRestaurantsWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedNearbyRestaurants)
        
        let receivedNearbyRestaurants = try await searchNearby(on: sut)
        
        XCTAssertEqual(receivedNearbyRestaurants, expectedNearbyRestaurants)
    }
    
    func test_searchNearby_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())
        
        do {
            let nearbyPlaces = try await searchNearby(on: sut)
            XCTFail("Expected to fail, got \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: NearbyRestaurantsServiceWithFallbackComposite, primaryStub: NearbyRestaurantsServiceStub, secondaryStub: NearbyRestaurantsServiceStub) {
        let primaryStub = NearbyRestaurantsServiceStub()
        let secondaryStub = NearbyRestaurantsServiceStub()
        let sut = NearbyRestaurantsServiceWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
    private func searchNearby(on sut: NearbyRestaurantsServiceWithFallbackComposite, location: Location? = nil, radius: Int = 0) async throws -> [NearbyRestaurant] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
}
