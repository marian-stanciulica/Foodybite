//
//  GetPlaceDetailsDAOTests.swift
//  FoodybitePersistenceTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain
import FoodybitePersistence

public final class GetPlaceDetailsDAO: GetPlaceDetailsService {
    private let store: LocalStoreReader & LocalStoreWriter

    init(store: LocalStoreReader & LocalStoreWriter) {
        self.store = store
    }
    
    public func getPlaceDetails(placeID: String) async throws -> PlaceDetails {
        return try await store.read()
    }
}

final class GetPlaceDetailsDAOTests: XCTestCase {
    
    func test_getPlaceDetails_throwsErrorWhenStoreThrowsError() async {
        let (sut, storeSpy) = makeSUT()
        storeSpy.readResult = .failure(anyError())
        
        do {
            let nearbyPlaces = try await sut.getPlaceDetails(placeID: "place #1")
            XCTFail("Expected to fail, received nearby places \(nearbyPlaces) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: GetPlaceDetailsDAO, storeSpy: LocalStoreSpy) {
        let storeSpy = LocalStoreSpy()
        let sut = GetPlaceDetailsDAO(store: storeSpy)
        return (sut, storeSpy)
    }
    
}
