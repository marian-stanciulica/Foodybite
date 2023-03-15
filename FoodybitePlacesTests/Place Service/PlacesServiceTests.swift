//
//  PlacesServiceTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces
import Domain

final class PlacesServiceTests: XCTestCase {
    
    // MARK: - AutocompletePlacesService
    
    func test_conformsToAutocompletePlacesService() {
        let (sut, _) = makeSUT(response: anyData())
        XCTAssertNotNil(sut as AutocompletePlacesService)
    }
    
    func test_autocomplete_usesAutocompleteEndpointToCreateURLRequest() async throws {
        let input = "input"
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let (sut, loader) = makeSUT(response: anyAutocompleteResponse())
        let autocompleteEndpoint = AutocompleteEndpoint(input: input, location: location, radius: radius)
        let urlRequest = try autocompleteEndpoint.createURLRequest()
        
        _ = try await sut.autocomplete(input: input, location: location, radius: radius)
        
        XCTAssertEqual(loader.getRequests, [urlRequest])
    }
    
    func test_autocomplete_throwsErrorWhenStatusIsNotOK() async {
        let input = "input"
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        let autocompleteResponse = anyAutocompleteResponse(status: .overQueryLimit)
        let (sut, _) = makeSUT(response: autocompleteResponse)
        
        do {
            let autocompletePredictions = try await sut.autocomplete(input: input, location: location, radius: radius)
            XCTFail("Expected to fail, got \(autocompletePredictions) instead")
        } catch {
            XCTAssertNotNil(error)
        }
    }
    
    func test_autocomplete_receiveExpectedAutocompleteResponse() async throws {
        let input = "input"
        let location = Location(latitude: -33.8670522, longitude: 151.1957362)
        let radius = 1500
        
        let expectedResponse = anyAutocompleteResponse()
        let expected = expectedResponse.predictions.map {
            AutocompletePrediction(placePrediction: $0.description, placeID: $0.placeID)
        }
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.autocomplete(input: input, location: location, radius: radius)
        XCTAssertEqual(expected, receivedResponse)
    }
    
    
    // MARK: - Helpers
    
    func makeSUT(response: Decodable) -> (sut: PlacesService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response)
        let sut = PlacesService(loader: loader)
        return (sut, loader)
    }
    
    private func anyAutocompleteResponse(status: AutocompleteStatus = .ok) -> AutocompleteResponse {
        AutocompleteResponse(
            predictions: [
                Prediction(description: "a description", matchedSubstrings: [], placeID: "place #1", reference: "", structuredFormatting: StructuredFormatting(mainText: "", mainTextMatchedSubstrings: [], secondaryText: ""), terms: [], types: []),
                Prediction(description: "another description", matchedSubstrings: [], placeID: "place #2", reference: "", structuredFormatting: StructuredFormatting(mainText: "", mainTextMatchedSubstrings: [], secondaryText: ""), terms: [], types: [])
            ],
            status: status
        )
    }
    
}
