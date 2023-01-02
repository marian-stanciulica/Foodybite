//
//  APIServiceTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces

final class APIServiceTests: XCTestCase {
    
    // MARK: - PlaceAutocompleteService Tests
    
    func test_conformsToPlaceAutocompleteService() {
        let (sut, _) = makeSUT()
        XCTAssertNotNil(sut as PlaceAutocompleteService)
    }
    
    func test_autocomplete_autocompleteParamsUsedToCreateEndpoint() async throws {
        let input = anyString()
        
        let (sut, loader) = makeSUT()
        let autocompleteEndpoint = PlacesEndpoint.autocomplete(input)
        let urlRequest = try autocompleteEndpoint.createURLRequest()
        
        _ = try await sut.autocomplete(input: input)
        
        let firstRequest = loader.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_autocomplete_usesAutocompleteEndpointToCreateURLRequest() async throws {
        let input = anyString()
        
        let (sut, loader) = makeSUT()
        let autocompleteEndpoint = PlacesEndpoint.autocomplete(input)
        let urlRequest = try autocompleteEndpoint.createURLRequest()
        
        _ = try await sut.autocomplete(input: input)
        
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_autocomplete_receiveExpectedAutocompleteResponse() async throws {
        let expectedResponse = anyAutocompleteResponse()
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.autocomplete(input: anyString())
        
        XCTAssertEqual(expectedResponse.predictions, receivedResponse)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(response: Decodable? = nil) -> (sut: APIService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response ?? anyAutocompleteResponse())
        let sut = APIService(loader: loader)
        return (sut, loader)
    }
    
    private func anyString() -> String {
        "any string"
    }
    
    private func anyAutocompleteResponse() -> AutocompleteResponse {
        AutocompleteResponse(predictions: [
            AutocompletePrediction(placeID: "place 1"),
            AutocompletePrediction(placeID: "place 2")
        ])
    }
}
