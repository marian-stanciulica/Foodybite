//
//  SearchNearbyDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import Testing
import Domain
import FoodybitePersistence

struct NearbyRestaurantsDAOTests {

    @Test func searchNearby_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy, _) = makeSUT()
        storeSpy.readResult = .failure(anyError())

        do {
            let nearbyRestaurants = try await searchNearby(on: sut)
            Issue.record("Expected to fail, received \(nearbyRestaurants) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func searchNearby_returnsFilteredNearbyRestaurantsWhenStoreReturnsSuccessfully() async throws {
        let (sut, storeSpy, distanceSolverStub) = makeSUT()
        let radius = 10
        distanceSolverStub.stub = [9, 11, 8]

        let nearbyRestaurants = makeNearbyRestaurants()
        storeSpy.readAllResult = .success(nearbyRestaurants)

        let receivedNearbyRestaurants = try await searchNearby(on: sut, radius: radius)
        #expect(receivedNearbyRestaurants == [nearbyRestaurants[0]] + [nearbyRestaurants[2]])
    }

    @Test func save_sendsNearbyRestaurantsToStore() async throws {
        let (sut, storeSpy, _) = makeSUT()
        let expectedNearbyRestaurants = makeNearbyRestaurants()

        try await sut.save(nearbyRestaurants: expectedNearbyRestaurants)

        #expect(storeSpy.messages.count == 1)

        if case let .writeAll(receivedNearbyRestaurants) = storeSpy.messages[0],
           let receivedNearbyRestaurants = receivedNearbyRestaurants as? [NearbyRestaurant] {
            #expect(expectedNearbyRestaurants == receivedNearbyRestaurants)
        } else {
            Issue.record("Expected .writeAll message, got \(storeSpy.messages[0]) instead")
        }
    }

    // MARK: - Helpers

    private func makeSUT() -> (sut: NearbyRestaurantsDAO, storeSpy: LocalStoreSpy, distanceProviderStub: DistanceProviderStub) {
        let storeSpy = LocalStoreSpy()
        let distanceProviderStub = DistanceProviderStub()
        let sut = NearbyRestaurantsDAO(store: storeSpy, getDistanceInKm: distanceProviderStub.getDistanceInKm)
        return (sut, storeSpy, distanceProviderStub)
    }

    private func anyLocation() -> Location {
        Location(latitude: 0, longitude: 0)
    }

    private func makeNearbyRestaurants() -> [NearbyRestaurant] {
        [
            NearbyRestaurant(
                id: "restaurant #1",
                name: "restaurant name 1",
                isOpen: true,
                rating: 3,
                location: Location(latitude: 2, longitude: 5),
                photo: nil),
            NearbyRestaurant(
                id: "restaurant #2",
                name: "restaurant name 2",
                isOpen: false,
                rating: 4,
                location: Location(latitude: 43, longitude: 56),
                photo: nil),
            NearbyRestaurant(
                id: "restaurant #3",
                name: "restaurant name 3",
                isOpen: true,
                rating: 5,
                location: Location(latitude: 3, longitude: 6),
                photo: nil)
        ]
    }

    private func searchNearby(on sut: NearbyRestaurantsDAO, location: Location? = nil, radius: Int = 0) async throws -> [NearbyRestaurant] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }

    private class DistanceProviderStub {
        var stub = [Double]()
        private var count = 0

        func getDistanceInKm(from source: Location, to destination: Location) -> Double {
            let distance = stub[count]
            count += 1
            return distance
        }
    }
}
