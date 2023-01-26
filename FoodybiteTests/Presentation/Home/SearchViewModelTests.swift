//
//  SearchViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
import DomainModels
import Foodybite
import FoodybitePlaces

final class SearchViewModelTests: XCTestCase {
    
    func test_searchResultsEmptyAfterInit() {
        let (sut, _) = makeSUT()

        XCTAssertTrue(sut.searchResults.isEmpty)
    }
    
    func test_autocomplete_returnsEmptyResultWhenAutocompleteServiceThrowsError() async {
        let (sut, autocompleteSpy) = makeSUT()
        let anyNSError = anyNSError()
        
        autocompleteSpy.result = .failure(anyNSError)
        await sut.autocomplete(input: randomString())
        
        XCTAssertTrue(sut.searchResults.isEmpty)
    }
    
    func test_autocomplete_returnsNonEmptyResultWhenAutocompleteServiceReturnsSuccessfully() async {
        let (sut, autocompleteSpy) = makeSUT()
        let expectedResult = anyAutocompletePredictions()
        
        autocompleteSpy.result = .success(expectedResult)
        await sut.autocomplete(input: randomString())
        
        XCTAssertEqual(expectedResult, sut.searchResults)
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> (sut: SearchViewModel, autocompleteService: PlaceAutocompleteSpy)  {
        let autocompleteService = PlaceAutocompleteSpy()
        let sut = SearchViewModel(service: autocompleteService)
        return (sut, autocompleteService)
    }
    
    private func anyAutocompletePredictions() -> [NearbyPlace] {
        [
            NearbyPlace(placeID: randomString(), placeName: randomString()),
            NearbyPlace(placeID: randomString(), placeName: randomString())
        ]
    }
    
    private class PlaceAutocompleteSpy: SearchNearbyService {
        var result: Result<[NearbyPlace], Error>?
        
        func autocomplete(input: String) async throws -> [NearbyPlace] {
            if let result = result {
                return try result.get()
            }
            
            return []
        }
    }
}
