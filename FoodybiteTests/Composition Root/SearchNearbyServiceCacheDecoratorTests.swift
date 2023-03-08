//
//  SearchNearbyServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import XCTest
import Domain
import Foodybite

final class SearchNearbyServiceCacheDecoratorTests: XCTestCase {
    
    func test_searchNearby_throwsErrorWhenSearchNearbyServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let nearbyPlaces = try await searchNearby(on: sut)
            XCTFail("Expected to fail, received nearby places \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_searchNearby_returnsNearbyPlacesWhenSearchNearbyServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedNearbyPlaces = makeNearbyPlaces()
        serviceStub.stub = .success(expectedNearbyPlaces)
        
        let receivedNearbyPlaces = try await searchNearby(on: sut)
        XCTAssertEqual(receivedNearbyPlaces, expectedNearbyPlaces)
    }
    
    func test_searchNearby_doesNotCacheWhenSearchNearbyServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        _ = try? await searchNearby(on: sut)
        
        XCTAssertTrue(cacheSpy.capturedValues.isEmpty)
    }
    
    func test_searchNearby_cachesNearbyPlacesWhenSearchNearbyServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedNearbyPlaces = makeNearbyPlaces()
        serviceStub.stub = .success(expectedNearbyPlaces)
        
        _ = try? await searchNearby(on: sut)
        
        XCTAssertEqual(cacheSpy.capturedValues, [expectedNearbyPlaces])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: SearchNearbyServiceCacheDecorator, serviceStub: SearchNearbyServiceStub, cacheSpy: SearchNearbyCacheSpy) {
        let serviceStub = SearchNearbyServiceStub()
        let cacheSpy = SearchNearbyCacheSpy()
        let sut = SearchNearbyServiceCacheDecorator(searchNearbyService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private func searchNearby(on sut: SearchNearbyServiceCacheDecorator, location: Location? = nil, radius: Int = 0) async throws -> [NearbyPlace] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
    
    private class SearchNearbyCacheSpy: SearchNearbyCache {
        private(set) var capturedValues = [[NearbyPlace]]()
        
        func save(nearbyPlaces: [NearbyPlace]) async throws {
            capturedValues.append(nearbyPlaces)
        }
    }
    
}
