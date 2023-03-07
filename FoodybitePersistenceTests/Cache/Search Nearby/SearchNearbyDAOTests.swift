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
    
    init(store: UserStore) {
        self.store = store
    }
    
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        try await store.readAll()
    }
}

final class SearchNearbyDAOTests: XCTestCase {
    
    func test_searchNearby_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let nearbyPlaces = try await searchNearby(on: sut)
            XCTFail("Expected to fail, received nearby places \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: SearchNearbyDAO, storeSpy: UserStoreSpy) {
        let storeSpy = UserStoreSpy()
        let sut = SearchNearbyDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
    private func anyError() -> NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private func anyLocation() -> Location {
        Location(latitude: 0, longitude: 0)
    }
    
    private func searchNearby(on sut: SearchNearbyDAO, location: Location? = nil, radius: Int = 0) async throws -> [NearbyPlace] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
}
