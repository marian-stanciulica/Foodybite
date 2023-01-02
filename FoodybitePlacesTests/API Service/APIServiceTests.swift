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
        let (sut, _) = makeSUT(response: anyAutocompleteResponse())
        XCTAssertNotNil(sut as PlaceAutocompleteService)
    }
    
    func test_autocomplete_autocompleteParamsUsedToCreateEndpoint() async throws {
        let input = randomString()
        
        let (sut, loader) = makeSUT(response: anyAutocompleteResponse())
        let autocompleteEndpoint = PlacesEndpoint.autocomplete(input)
        let urlRequest = try autocompleteEndpoint.createURLRequest()
        
        _ = try await sut.autocomplete(input: input)
        
        let firstRequest = loader.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_autocomplete_usesAutocompleteEndpointToCreateURLRequest() async throws {
        let input = randomString()
        
        let (sut, loader) = makeSUT(response: anyAutocompleteResponse())
        let autocompleteEndpoint = PlacesEndpoint.autocomplete(input)
        let urlRequest = try autocompleteEndpoint.createURLRequest()
        
        _ = try await sut.autocomplete(input: input)
        
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_autocomplete_receiveExpectedAutocompleteResponse() async throws {
        let expectedResponse = anyAutocompleteResponse()
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.autocomplete(input: randomString())
        
        XCTAssertEqual(expectedResponse.predictions, receivedResponse)
    }
    
    // MARK: - GetPlaceDetails Tests
    
    func test_conformsToGetPlaceDetailsService() {
        let (sut, _) = makeSUT(response: anyPlaceDetails())
        XCTAssertNotNil(sut as GetPlaceDetailsService)
    }
    
    func test_getPlaceDetails_getPlaceDetailsParamsUsedToCreateEndpoint() async throws {
        let placeID = randomString()
        
        let (sut, loader) = makeSUT(response: anyPlaceDetails())
        let getPlaceDetailsEndpoint = PlacesEndpoint.getPlaceDetails(placeID)
        let urlRequest = try getPlaceDetailsEndpoint.createURLRequest()
        
        _ = try await sut.getPlaceDetails(placeID: placeID)
        
        let firstRequest = loader.requests.first
        XCTAssertEqual(firstRequest?.httpBody, urlRequest.httpBody)
    }
    
    func test_getPlaceDetails_usesGetPlaceDetailsEndpointToCreateURLRequest() async throws {
        let placeID = randomString()

        let (sut, loader) = makeSUT(response: anyPlaceDetails())
        let getPlaceDetailsEndpoint = PlacesEndpoint.getPlaceDetails(placeID)
        let urlRequest = try getPlaceDetailsEndpoint.createURLRequest()
        
        _ = try await sut.getPlaceDetails(placeID: placeID)
        
        XCTAssertEqual(loader.requests, [urlRequest])
    }
    
    func test_getPlaceDetails_receiveExpectedPlaceDetailsResponse() async throws {
        let expectedResponse = anyPlaceDetails()
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.getPlaceDetails(placeID: randomString())
        
        XCTAssertEqual(expectedResponse, receivedResponse)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(response: Decodable) -> (sut: APIService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response)
        let sut = APIService(loader: loader)
        return (sut, loader)
    }
    
    private func anyAutocompleteResponse() -> AutocompleteResponse {
        AutocompleteResponse(predictions: [
            AutocompletePrediction(placeID: "place 1", placeName: "place 1 name"),
            AutocompletePrediction(placeID: "place 2", placeName: "place 2 name")
        ])
    }
    
    private func anyPlaceDetails() -> PlaceDetails {
        PlaceDetails(name: "Test Restaurant")
    }
}
