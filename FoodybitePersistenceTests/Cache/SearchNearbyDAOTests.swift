//
//  SearchNearbyDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class SearchNearbyDAOTests: XCTestCase {
    
    func test_searchNearby_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy, _) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let nearbyPlaces = try await searchNearby(on: sut)
            XCTFail("Expected to fail, received nearby places \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_searchNearby_returnsFilteredNearbyPlacesWhenStoreReturnsSuccessfully() async throws {
        let (sut, storeSpy, distanceSolverStub) = makeSUT()
        let radius = 10
        distanceSolverStub.stub = [9, 11, 8]
        
        let nearbyPlaces = makeNearbyRestaurants()
        storeSpy.readAllResult = .success(nearbyPlaces)
        
        let receivedNearbyPlaces = try await searchNearby(on: sut, radius: radius)
        XCTAssertEqual(receivedNearbyPlaces, [nearbyPlaces[0]] + [nearbyPlaces[2]])
    }
    
    func test_save_sendsNearbyPlacesToStore() async throws {
        let (sut, storeSpy, _) = makeSUT()
        let expectedNearbyPlaces = makeNearbyRestaurants()
        
        try await sut.save(nearbyPlaces: expectedNearbyPlaces)
        
        XCTAssertEqual(storeSpy.messages.count, 1)
        
        if case let .writeAll(receivedNearbyPlaces) = storeSpy.messages[0] {
            XCTAssertEqual(expectedNearbyPlaces, receivedNearbyPlaces as! [NearbyRestaurant])
        } else {
            XCTFail("Expected .writeAll message, got \(storeSpy.messages[0]) instead")
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
                placeID: "place #1",
                placeName: "Place name 1",
                isOpen: true,
                rating: 3,
                location: Location(latitude: 2, longitude: 5),
                photo: nil),
            NearbyRestaurant(
                placeID: "place #2",
                placeName: "Place name 2",
                isOpen: false,
                rating: 4,
                location: Location(latitude: 43, longitude: 56),
                photo: nil),
            NearbyRestaurant(
                placeID: "place #3",
                placeName: "Place name 3",
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
