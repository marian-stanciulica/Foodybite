//
//  NearbyRestaurantsServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import XCTest
import Domain
import Foodybite

final class NearbyRestaurantsServiceCacheDecoratorTests: XCTestCase {
    
    func test_searchNearby_throwsErrorWhenServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let nearbyRestaurants = try await searchNearby(on: sut)
            XCTFail("Expected to fail, received \(nearbyRestaurants) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_searchNearby_returnsNearbyRestaurantsWhenServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        serviceStub.stub = .success(expectedNearbyRestaurants)
        
        let receivedNearbyRestaurants = try await searchNearby(on: sut)
        XCTAssertEqual(receivedNearbyRestaurants, expectedNearbyRestaurants)
    }
    
    func test_searchNearby_doesNotCacheWhenServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        _ = try? await searchNearby(on: sut)
        
        XCTAssertTrue(cacheSpy.capturedValues.isEmpty)
    }
    
    func test_searchNearby_cachesNearbyRestaurantsWhenServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        serviceStub.stub = .success(expectedNearbyRestaurants)
        
        _ = try? await searchNearby(on: sut)
        
        XCTAssertEqual(cacheSpy.capturedValues, [expectedNearbyRestaurants])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: NearbyRestaurantsServiceCacheDecorator, serviceStub: SearchNearbyServiceStub, cacheSpy: SearchNearbyCacheSpy) {
        let serviceStub = SearchNearbyServiceStub()
        let cacheSpy = SearchNearbyCacheSpy()
        let sut = NearbyRestaurantsServiceCacheDecorator(nearbyRestaurantsService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private func searchNearby(on sut: NearbyRestaurantsServiceCacheDecorator, location: Location? = nil, radius: Int = 0) async throws -> [NearbyRestaurant] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
    
    private class SearchNearbyCacheSpy: NearbyRestaurantsCache {
        private(set) var capturedValues = [[NearbyRestaurant]]()
        
        func save(nearbyPlaces: [NearbyRestaurant]) async throws {
            capturedValues.append(nearbyPlaces)
        }
    }
    
}
