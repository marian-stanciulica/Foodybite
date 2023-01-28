//
//  HomeViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import DomainModels
import Foodybite

final class HomeViewModelTests: XCTestCase {
    
    func test_searchNearby_sendsInputsToSearchNearbyService() async {
        let (sut, serviceSpy) = makeSUT()
        
        await sut.searchNearby(location: location, radius: radius)
        
        XCTAssertEqual(serviceSpy.capturedValues[0].radius, radius)
        XCTAssertEqual(serviceSpy.capturedValues[0].location, location)
    }
    
    func test_searchNearby_setsErrorWhenSearchNearbyServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        
        serviceSpy.result = .failure(anyError)
        await sut.searchNearby(location: location, radius: radius)
        XCTAssertEqual(sut.error, .connectionFailure)
        
        serviceSpy.result = nil
        await sut.searchNearby(location: location, radius: radius)
        XCTAssertNil(sut.error)
    }
    
    func test_searchNearby_updatesNearbyPlacesWhenSearchNearbyServiceReturnsSuccessfully() async {
        let (sut, serviceSpy) = makeSUT()
        let expectedNearbyPlaces = anyNearbyPlaces
        
        serviceSpy.result = .success(expectedNearbyPlaces)
        await sut.searchNearby(location: location, radius: radius)
        XCTAssertEqual(sut.nearbyPlaces, expectedNearbyPlaces)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: HomeViewModel, serviceSpy: SearchNearbyServiceSpy) {
        let serviceSpy = SearchNearbyServiceSpy()
        let sut = HomeViewModel(searchNearbyService: serviceSpy)
        return (sut, serviceSpy)
    }
    
    private var location: Location {
        Location(latitude: -31.3223245, longitude: 132.45432)
    }
    
    private var radius: Int {
        50
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private var anyNearbyPlaces: [NearbyPlace] {
        [
            NearbyPlace(placeID: "#1", placeName: "place 1", isOpen: false, rating: 2.3),
            NearbyPlace(placeID: "#2", placeName: "place 2", isOpen: true, rating: 4.4),
            NearbyPlace(placeID: "#3", placeName: "place 3", isOpen: false, rating: 4.5)
        ]
    }
    
    private class SearchNearbyServiceSpy: SearchNearbyService {
        var result: Result<[NearbyPlace], Error>?
        private(set) var capturedValues = [(location: Location, radius: Int)]()
        
        func searchNearby(location: Location, radius: Int) async throws -> [NearbyPlace] {
            capturedValues.append((location, radius))

            if let result = result {
                return try result.get()
            }
            
            return []
        }
    }
    
}
