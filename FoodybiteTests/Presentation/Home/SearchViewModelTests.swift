//
//  SearchViewModelTests.swift
//  FoodybiteTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
import Foodybite
import FoodybitePlaces

class SearchViewModel {
    let service: PlaceAutocompleteService
    
    init(service: PlaceAutocompleteService) {
        self.service = service
    }
    
    func autocomplete(input: String) async -> [AutocompletePrediction] {
        do {
            return try await service.autocomplete(input: input)
        } catch {
            return []
        }
    }
}

final class SearchViewModelTests: XCTestCase {
    
    func test_autocomplete_returnsEmptyResultWhenAutocompleteServiceThrowsError() async {
        let (sut, autocompleteSpy) = makeSUT()
        let anyNSError = anyNSError()
        
        autocompleteSpy.result = .failure(anyNSError)
        
        let response = await sut.autocomplete(input: randomString())
        XCTAssertTrue(response.isEmpty)
    }
    
    // MARK: Helpers
    
    private func makeSUT() -> (sut: SearchViewModel, autocompleteService: PlaceAutocompleteSpy)  {
        let autocompleteService = PlaceAutocompleteSpy()
        let sut = SearchViewModel(service: autocompleteService)
        return (sut, autocompleteService)
    }
                               
    private class PlaceAutocompleteSpy: PlaceAutocompleteService {
        var result: Result<[AutocompletePrediction], Error>?
        
        func autocomplete(input: String) async throws -> [AutocompletePrediction] {
            if let result = result {
                return try result.get()
            }
            
            return []
        }
    }
}
