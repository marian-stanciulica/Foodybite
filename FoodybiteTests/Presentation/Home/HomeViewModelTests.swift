//
//  HomeViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 28.01.2023.
//

import XCTest
import Domain
import Foodybite

final class HomeViewModelTests: XCTestCase {
    
    func test_init_searchText() {
        let (sut, _) = makeSUT()

        XCTAssertTrue(sut.searchText.isEmpty)
    }
    
    func test_init_searchNearbyState() {
        let (sut, _) = makeSUT()

        XCTAssertEqual(sut.searchNearbyState, .idle)
    }
    
    func test_searchNearby_setsErrorWhenSearchNearbyServiceThrowsError() async {
        let (sut, serviceSpy) = makeSUT()
        serviceSpy.result = .failure(anyError)
        
        await assert(on: sut, withExpectedResult: .failure(.serverError))
    }
    
    func test_searchNearby_updatesNearbyPlacesWhenSearchNearbyServiceReturnsSuccessfully() async {
        let (sut, serviceSpy) = makeSUT()
        let expectedNearbyPlaces = anyNearbyPlaces
        serviceSpy.result = .success(expectedNearbyPlaces)
        
        await assert(on: sut, withExpectedResult: .success(expectedNearbyPlaces))
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: HomeViewModel, serviceSpy: SearchNearbyServiceSpy) {
        let serviceSpy = SearchNearbyServiceSpy()
        let sut = HomeViewModel(searchNearbyService: serviceSpy, currentLocation: anyLocation)
        return (sut, serviceSpy)
    }
    
    private func assert(on sut: HomeViewModel,
                        withExpectedResult expectedResult: HomeViewModel.State,
                        file: StaticString = #file,
                        line: UInt = #line) async {
        let resultSpy = PublisherSpy(sut.$searchNearbyState.eraseToAnyPublisher())

        XCTAssertEqual(resultSpy.results, [.idle], file: file, line: line)
        
        await sut.searchNearby()
        
        XCTAssertEqual(resultSpy.results, [.idle, .isLoading, expectedResult], file: file, line: line)
        resultSpy.cancel()
    }
    
    private var anyError: NSError {
        NSError(domain: "any error", code: 1)
    }
    
    private var anyLocation: Location {
        Location(latitude: 2.3, longitude: 4.5)
    }
    
    private var anyNearbyPlaces: [NearbyPlace] {
        [
            NearbyPlace(placeID: "#1", placeName: "place 1", isOpen: false, rating: 2.3, location: Location(latitude: 0, longitude: 1), photo: nil),
            NearbyPlace(placeID: "#2", placeName: "place 2", isOpen: true, rating: 4.4, location: Location(latitude: 2, longitude: 3), photo: nil),
            NearbyPlace(placeID: "#3", placeName: "place 3", isOpen: false, rating: 4.5, location: Location(latitude: 4, longitude: 5), photo: nil)
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
