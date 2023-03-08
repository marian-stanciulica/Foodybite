//
//  SearchNearbyServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import Foodybite

final class SearchNearbyServiceWithFallbackCompositeTests: XCTestCase {
    
    func test_searchNearby_returnsNearbyPlacesWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedNearbyPlaces = makeNearbyPlaces()
        primaryStub.stub = .success(expectedNearbyPlaces)
        
        let receivedNearbyPlaces = try await searchNearby(on: sut)
        
        XCTAssertEqual(receivedNearbyPlaces, expectedNearbyPlaces)
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
    
    func test_searchNearby_returnsNearbyPlacesWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedNearbyPlaces = makeNearbyPlaces()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedNearbyPlaces)
        
        let receivedNearbyPlaces = try await searchNearby(on: sut)
        
        XCTAssertEqual(expectedNearbyPlaces, receivedNearbyPlaces)
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
    
    private func makeSUT() -> (sut: SearchNearbyServiceWithFallbackComposite, primaryStub: SearchNearbyServiceStub, secondaryStub: SearchNearbyServiceStub) {
        let primaryStub = SearchNearbyServiceStub()
        let secondaryStub = SearchNearbyServiceStub()
        let sut = SearchNearbyServiceWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }
    
    private func searchNearby(on sut: SearchNearbyServiceWithFallbackComposite, location: Location? = nil, radius: Int = 0) async throws -> [NearbyPlace] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
}
