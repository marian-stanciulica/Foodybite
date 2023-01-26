//
//  APIServiceTests.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 02.01.2023.
//

import XCTest
@testable import FoodybitePlaces
import DomainModels

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
        let expected = expectedResponse.predictions.map {
            AutocompletePrediction(placeID: $0.placeID, placeName: $0.structuredFormatting.placeName)
        }
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.autocomplete(input: randomString())
        XCTAssertEqual(expected, receivedResponse)
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
        let expected = PlaceDetails(name: expectedResponse.result.name)
        let (sut, _) = makeSUT(response: expectedResponse)
        
        let receivedResponse = try await sut.getPlaceDetails(placeID: randomString())
        
        XCTAssertEqual(expected, receivedResponse)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(response: Decodable) -> (sut: APIService, loader: ResourceLoaderSpy) {
        let loader = ResourceLoaderSpy(response: response)
        let sut = APIService(loader: loader)
        return (sut, loader)
    }
    
    private func anyAutocompleteResponse() -> AutocompleteResponse {
        AutocompleteResponse(predictions: [
            Prediction(
                description: "a description",
                matchedSubstrings: [],
                placeID: "place id #1",
                reference: "",
                structuredFormatting:
                    StructuredFormatting(placeName: "a place name",
                                         mainTextMatchedSubstrings: [],
                                         secondaryText: ""),
                terms: [],
                types: [])
        ], status: "OK")
    }
    
    private func anyPlaceDetails() -> PlaceDetailsResponse {
        PlaceDetailsResponse(
            result: Details(
                addressComponents: [],
                businessStatus: "",
                formattedAddress: "",
                formattedPhoneNumber: "",
                geometry: Geometry(
                    location: Location(lat: 0, lng: 0),
                    viewport: Viewport(northeast: Location(lat: 0, lng: 0),
                                       southwest: Location(lat: 0, lng: 0))),
                icon: "",
                iconBackgroundColor: "",
                iconMaskBaseURI: "",
                internationalPhoneNumber: "",
                name: "place 1",
                openingHours: OpeningHours(openNow: false, periods: [], weekdayText: []),
                photos: [],
                placeID: "",
                plusCode: PlusCode(compoundCode: "", globalCode: ""),
                rating: 0,
                reference: "",
                reviews: [],
                types: [],
                url: "",
                userRatingsTotal: 0,
                utcOffset: 0,
                vicinity: "",
                website: ""),
            status: ""
        )
    }
}
