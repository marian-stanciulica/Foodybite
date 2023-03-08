//
//  SearchNearbyServiceWithFallbackCompositeTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 08.03.2023.
//

import XCTest
import Domain

final class SearchNearbyServiceWithFallbackComposite: SearchNearbyService {
    private let primary: SearchNearbyService
    
    init(primary: SearchNearbyService) {
        self.primary = primary
    }
    
    func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
        try await primary.searchNearby(location: location, radius: radius)
    }
}

final class SearchNearbyServiceWithFallbackCompositeTests: XCTestCase {
    
    func test_searchNearby_returnsNearbyPlacesWhenPrimaryReturnsSuccessfully() async throws {
        let (sut, primaryStub) = makeSUT()
        let expectedNearbyPlaces = makeNearbyPlaces()
        primaryStub.stub = .success(expectedNearbyPlaces)
        
        let receivedNearbyPlaces = try await searchNearby(on: sut)
        
        XCTAssertEqual(receivedNearbyPlaces, expectedNearbyPlaces)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: SearchNearbyServiceWithFallbackComposite, primaryStub: SearchNearbyServiceStub) {
        let primaryStub = SearchNearbyServiceStub()
        let sut = SearchNearbyServiceWithFallbackComposite(primary: primaryStub)
        return (sut, primaryStub)
    }
    
    private func searchNearby(on sut: SearchNearbyServiceWithFallbackComposite, location: Location? = nil, radius: Int = 0) async throws -> [NearbyPlace] {
        return try await sut.searchNearby(location: location ?? anyLocation(), radius: radius)
    }
}
