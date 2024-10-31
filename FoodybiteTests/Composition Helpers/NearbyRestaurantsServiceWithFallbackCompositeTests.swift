//
//  NearbyRestaurantsServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import Testing
import Domain
import Foodybite

struct NearbyRestaurantsServiceWithFallbackCompositeTests {

    @Test func searchNearby_returnsNearbyRestaurantsWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, _) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        primaryStub.stub = .success(expectedNearbyRestaurants)

        let receivedNearbyRestaurants = try await searchNearby(on: sut)

        #expect(receivedNearbyRestaurants == expectedNearbyRestaurants)
    }

    @Test func searchNearby_callsSecondaryWhenPrimaryThrowsError() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedLocation = anyLocation()
        let expectedRadius = 100
        primaryStub.stub = .failure(anyError())

        _ = try await searchNearby(on: sut, location: expectedLocation, radius: expectedRadius)

        #expect(secondaryStub.capturedValues.count == 1)
        #expect(secondaryStub.capturedValues[0].location == expectedLocation)
        #expect(secondaryStub.capturedValues[0].radius == expectedRadius)
    }

    @Test func searchNearby_returnsNearbyRestaurantsWhenPrimaryThrowsErrorAndSecondaryReturnsSuccessfully() async throws {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .success(expectedNearbyRestaurants)

        let receivedNearbyRestaurants = try await searchNearby(on: sut)

        #expect(receivedNearbyRestaurants == expectedNearbyRestaurants)
    }

    @Test func searchNearby_throwsErrorWhenPrimaryThrowsErrorAndSecondaryThrowsError() async {
        let (sut, primaryStub, secondaryStub) = makeSUT()
        primaryStub.stub = .failure(anyError())
        secondaryStub.stub = .failure(anyError())

        do {
            let nearbyRestaurants = try await searchNearby(on: sut)
            Issue.record("Expected to fail, got \(nearbyRestaurants) instead")
        } catch {
            #expect(error != nil)
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> (
        sut: NearbyRestaurantsServiceWithFallbackComposite,
        primaryStub: NearbyRestaurantsServiceStub,
        secondaryStub: NearbyRestaurantsServiceStub
    ) {
        let primaryStub = NearbyRestaurantsServiceStub()
        let secondaryStub = NearbyRestaurantsServiceStub()
        let sut = NearbyRestaurantsServiceWithFallbackComposite(primary: primaryStub, secondary: secondaryStub)
        return (sut, primaryStub, secondaryStub)
    }

    private func searchNearby(
        on sut: NearbyRestaurantsServiceWithFallbackComposite,
        location: Location? = nil,
        radius: Int = 0
    ) async throws -> [NearbyRestaurant] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
}
