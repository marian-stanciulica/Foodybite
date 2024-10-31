//
//  NearbyRestaurantsServiceCacheDecoratorTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Testing
import Domain
import Foodybite

struct NearbyRestaurantsServiceCacheDecoratorTests {

    @Test func searchNearby_throwsErrorWhenServiceThrowsError() async {
        let (sut, serviceStub, _) = makeSUT()
        serviceStub.stub = .failure(anyError())

        do {
            let nearbyRestaurants = try await searchNearby(on: sut)
            Issue.record("Expected to fail, received \(nearbyRestaurants) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func searchNearby_returnsNearbyRestaurantsWhenServiceReturnsSuccessfully() async throws {
        let (sut, serviceStub, _) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        serviceStub.stub = .success(expectedNearbyRestaurants)

        let receivedNearbyRestaurants = try await searchNearby(on: sut)
        #expect(receivedNearbyRestaurants == expectedNearbyRestaurants)
    }

    @Test func searchNearby_doesNotCacheWhenServiceThrowsError() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        serviceStub.stub = .failure(anyError())

        _ = try? await searchNearby(on: sut)

        #expect(cacheSpy.capturedValues.isEmpty)
    }

    @Test func searchNearby_cachesNearbyRestaurantsWhenServiceReturnsSuccessfully() async {
        let (sut, serviceStub, cacheSpy) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        serviceStub.stub = .success(expectedNearbyRestaurants)

        _ = try? await searchNearby(on: sut)

        #expect(cacheSpy.capturedValues == [expectedNearbyRestaurants])
    }

    // MARK: - Helpers

    private func makeSUT() -> (
        sut: NearbyRestaurantsServiceCacheDecorator,
        serviceStub: NearbyRestaurantsServiceStub,
        cacheSpy: SearchNearbyCacheSpy
    ) {
        let serviceStub = NearbyRestaurantsServiceStub()
        let cacheSpy = SearchNearbyCacheSpy()
        let sut = NearbyRestaurantsServiceCacheDecorator(nearbyRestaurantsService: serviceStub, cache: cacheSpy)
        return (sut, serviceStub, cacheSpy)
    }

    private func searchNearby(
        on sut: NearbyRestaurantsServiceCacheDecorator,
        location: Location? = nil,
        radius: Int = 0
    ) async throws -> [NearbyRestaurant] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }

    private class SearchNearbyCacheSpy: NearbyRestaurantsCache {
        private(set) var capturedValues = [[NearbyRestaurant]]()

        func save(nearbyRestaurants: [NearbyRestaurant]) async throws {
            capturedValues.append(nearbyRestaurants)
        }
    }

}
