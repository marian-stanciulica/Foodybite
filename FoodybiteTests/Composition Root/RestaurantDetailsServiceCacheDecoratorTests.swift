//
//  RestaurantDetailsServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import Foodybite

final class RestaurantDetailsServiceCacheDecoratorTests: XCTestCase {
    
    func test_getRestaurantDetails_throwsErrorWhenServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        do {
            let restaurantDetails = try await sut.getRestaurantDetails(placeID: "place id")
            XCTFail("Expected to fail, received \(restaurantDetails) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_getRestaurantDetails_returnsRestaurantDetailsWhenServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        serviceStub.stub = .success(expectedRestaurantDetails)
        
        let receivedRestaurantDetails = try await sut.getRestaurantDetails(placeID: expectedRestaurantDetails.placeID)
        XCTAssertEqual(receivedRestaurantDetails, expectedRestaurantDetails)
    }
    
    func test_getRestaurantDetails_doesNotCacheWhenPlaceDetailsServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())
        
        _ = try? await sut.getRestaurantDetails(placeID: "place id")
        
        XCTAssertTrue(cacheSpy.capturedValues.isEmpty)
    }
    
    func test_getRestaurantDetails_cachesRestaurantDetailsWhenServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedRestaurantDetails = makeRestaurantDetails()
        serviceStub.stub = .success(expectedRestaurantDetails)
        
        _ = try? await sut.getRestaurantDetails(placeID: expectedRestaurantDetails.placeID)
        
        XCTAssertEqual(cacheSpy.capturedValues, [expectedRestaurantDetails])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: RestaurantDetailsServiceCacheDecorator, serviceStub: RestaurantDetailsServiceStub, cacheSpy: PlaceDetailsCacheSpy) {
        let serviceStub = RestaurantDetailsServiceStub()
        let cacheSpy = PlaceDetailsCacheSpy()
        let sut = RestaurantDetailsServiceCacheDecorator(restaurantDetailsService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }
    
    private class PlaceDetailsCacheSpy: RestaurantDetailsCache {
        private(set) var capturedValues = [RestaurantDetails]()
        
        func save(placeDetails: RestaurantDetails) async throws {
            capturedValues.append(placeDetails)
        }
    }
}
