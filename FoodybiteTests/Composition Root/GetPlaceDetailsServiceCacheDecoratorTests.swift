//
//  GetPlaceDetailsServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import Foodybite

final class GetPlaceDetailsServiceCacheDecoratorTests: XCTestCase {
    
    func test_getPlaceDetails_throwsErrorWhenPlaceDetailsServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let nearbyPlaces = try await sut.getRestaurantDetails(placeID: "place id")
            XCTFail("Expected to fail, received nearby places \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getPlaceDetails_returnsPlaceDetailsWhenPlaceDetailsServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedPlaceDetails = makeExpectedPlaceDetails()
        serviceStub.stub = .success(expectedPlaceDetails)
        
        let receivedPlaceDetails = try await sut.getRestaurantDetails(placeID: expectedPlaceDetails.placeID)
        XCTAssertEqual(receivedPlaceDetails, expectedPlaceDetails)
    }
    
    func test_getPlaceDetails_doesNotCacheWhenPlaceDetailsServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        _ = try? await sut.getRestaurantDetails(placeID: "place id")
        
        XCTAssertTrue(cacheSpy.capturedValues.isEmpty)
    }
    
    func test_getPlaceDetails_cachesPlaceDetailsWhenPlaceDetailsServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedPlaceDetails = makeExpectedPlaceDetails()
        serviceStub.stub = .success(expectedPlaceDetails)
        
        _ = try? await sut.getRestaurantDetails(placeID: expectedPlaceDetails.placeID)
        
        XCTAssertEqual(cacheSpy.capturedValues, [expectedPlaceDetails])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetPlaceDetailsServiceCacheDecorator, serviceStub: GetPlaceDetailsServiceStub, cacheSpy: PlaceDetailsCacheSpy) {
        let serviceStub = GetPlaceDetailsServiceStub()
        let cacheSpy = PlaceDetailsCacheSpy()
        let sut = GetPlaceDetailsServiceCacheDecorator(getPlaceDetailsService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private class PlaceDetailsCacheSpy: PlaceDetailsCache {
        private(set) var capturedValues = [RestaurantDetails]()
        
        func save(placeDetails: RestaurantDetails) async throws {
            capturedValues.append(placeDetails)
        }
    }
}
