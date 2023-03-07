//
//  SearchNearbyDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 07.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

final class SearchNearbyDAO {
    private let store: UserStore
    private let getDistanceInKm: (Location, Location) -> Double
    
    init(store: UserStore, getDistanceInKm: @escaping (Location, Location) -> Double) {
        self.store = store
        self.getDistanceInKm = getDistanceInKm
    }
    
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        try await store.readAll()
            .filter {
                let distance = getDistanceInKm(location, $0.location)
                return Int(distance) < radius
            }
    }
}

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
        
        let nearbyPlaces = makeNearbyPlaces()
        storeSpy.readAllResult = .success(nearbyPlaces)
        
        let receivedNearbyPlaces = try await searchNearby(on: sut, radius: radius)
        XCTAssertEqual(receivedNearbyPlaces, [nearbyPlaces[0]] + [nearbyPlaces[2]])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: SearchNearbyDAO, storeSpy: UserStoreSpy, distanceProviderStub: DistanceProviderStub) {
        let storeSpy = UserStoreSpy()
        let distanceProviderStub = DistanceProviderStub()
        let sut = SearchNearbyDAO(store: storeSpy, getDistanceInKm: distanceProviderStub.getDistanceInKm)
        return (sut, storeSpy, distanceProviderStub)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyLocation() -> Location {
        Location(latitude: 0, longitude: 0)
    }
    
    private func makeNearbyPlaces() -> [NearbyPlace] {
        [
            NearbyPlace(
                placeID: "place #1",
                placeName: "Place name 1",
                isOpen: true,
                rating: 3,
                location: Location(latitude: 2, longitude: 5),
                photo: nil),
            NearbyPlace(
                placeID: "place #2",
                placeName: "Place name 2",
                isOpen: false,
                rating: 4,
                location: Location(latitude: 43, longitude: 56),
                photo: nil),
            NearbyPlace(
                placeID: "place #3",
                placeName: "Place name 3",
                isOpen: true,
                rating: 5,
                location: Location(latitude: 3, longitude: 6),
                photo: nil)
        ]
    }
    
    private func searchNearby(on sut: SearchNearbyDAO, location: Location? = nil, radius: Int = 0) async throws -> [NearbyPlace] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
    
    private class DistanceProviderStub: DistanceProvider {
        var stub = [Double]()
        private var count = 0
        
        func getDistanceInKm(from source: Location, to destination: Location) -> Double {
            let distance = stub[count]
            count += 1
            return distance
        }
    }
}
