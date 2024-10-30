//
//  PlacesServiceTests+AutocompletePlacesService.swift
//  FoodybitePlacesTests
//
//  Created by Marian Stanciulica on 15.03.2023.
//

import Testing
import Foundation.NSURLRequest
@testable import FoodybitePlaces
import Domain

extension PlacesServiceTests {

    @Test func conformsToAutocompleteRestaurantsService() {
        let (sut, _) = makeSUT(response: anyData())
        #expect(sut as AutocompleteRestaurantsService != nil)
    }

    @Test func autocomplete_usesAutocompleteEndpointToCreateURLRequest() async throws {
        let input = "input"
        let location = Location(latitude: -33.8, longitude: 15.1)
        let radius = 15

        let (sut, loader) = makeSUT(response: anyAutocompleteResponse())
        let endpoint = AutocompleteEndpoint(input: input, location: location, radius: radius)

        _ = try await sut.autocomplete(input: input, location: location, radius: radius)

        #expect(loader.getRequests.count == 1)
        assertURLComponents(
            urlRequest: loader.getRequests[0],
            input: input,
            location: location,
            radius: radius,
            apiKey: endpoint.apiKey
        )
    }

    @Test func autocomplete_throwsErrorWhenStatusIsNotOK() async {
        let autocompleteResponse = anyAutocompleteResponse(status: .overQueryLimit)
        let (sut, _) = makeSUT(response: autocompleteResponse)

        do {
            let autocompletePredictions = try await autocomplete(on: sut)
            Issue.record("Expected to fail, got \(autocompletePredictions) instead")
        } catch {
            #expect(error != nil)
        }
    }

    @Test func autocomplete_receiveExpectedAutocompleteResponse() async throws {
        let expectedAutocompleteResponse = anyAutocompleteResponse()
        let (sut, _) = makeSUT(response: expectedAutocompleteResponse)

        let receivedAutocompletePredictions = try await autocomplete(on: sut)

        #expect(expectedAutocompleteResponse.autocompletePredictions == receivedAutocompletePredictions)
    }

    // MARK: - Helpers

    private func assertURLComponents(
        urlRequest: URLRequest,
        input: String,
        location: Location,
        radius: Int,
        apiKey: String,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let expectedQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "input", value: input),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "location", value: "\(location.latitude),\(location.longitude)"),
            URLQueryItem(name: "radius", value: "\(radius)"),
            URLQueryItem(name: "type", value: "restaurant")
        ]

        assertURLComponents(
            urlRequest: urlRequest,
            path: "/maps/api/place/autocomplete/json",
            expectedQueryItems: expectedQueryItems,
            sourceLocation: sourceLocation)
    }

    private func autocomplete(
        on sut: PlacesService,
        input: String? = nil,
        location: Location? = nil,
        radius: Int? = nil
    ) async throws -> [AutocompletePrediction] {
        let defaultInput = "input"
        let defaultLocation = Location(latitude: -33.8, longitude: 15.1)
        let defaultRadius = 15

        return try await sut.autocomplete(
            input: input ?? defaultInput,
            location: location ?? defaultLocation,
            radius: radius ?? defaultRadius
        )
    }

    private func anyAutocompleteResponse(status: AutocompleteStatus = .okStatus) -> AutocompleteResponse {
        AutocompleteResponse(
            predictions: [
                Prediction(
                    description: "a description",
                    matchedSubstrings: [],
                    placeID: "place #1",
                    reference: "",
                    structuredFormatting: StructuredFormatting(
                        mainText: "",
                        mainTextMatchedSubstrings: [],
                        secondaryText: ""
                    ),
                    terms: [],
                    types: []
                ),
                Prediction(
                    description: "another description",
                    matchedSubstrings: [],
                    placeID: "place #2",
                    reference: "",
                    structuredFormatting: StructuredFormatting(
                        mainText: "",
                        mainTextMatchedSubstrings: [],
                        secondaryText: ""
                    ),
                    terms: [],
                    types: []
                )
            ],
            status: status
        )
    }

}
